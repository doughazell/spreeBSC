module Spree
  class OrdersController < Spree::StoreController
    ssl_required :show

    before_filter :check_authorization
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/products', 'spree/orders'

    respond_to :html

    def show
      @order = Order.find_by_number!(params[:id])
    end

    def update
      @order = current_order
      unless @order
        flash[:error] = Spree.t(:order_not_found)
        redirect_to root_path and return
      end

      if @order.update_attributes(params[:order])
        @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
        @order.create_proposed_shipments if @order.shipments.any?
        return if after_update_attributes

        fire_event('spree.order.contents_changed')

        respond_with(@order) do |format|
          format.html do
            if params.has_key?(:checkout)
              @order.next_transition.run_callbacks if @order.cart?
              redirect_to checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path
            end
          end
        end
      else
        respond_with(@order)
      end
    end

    # Shows the current incomplete order from the session
    def edit
      @order = current_order(true)
      associate_user
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      populator = Spree::OrderPopulator.new(current_order(true), current_currency)

      # 17/10/13 DH: Added 'price' to be later added to 'variant'
      if populator.populate(params.slice(:products, :variants, :quantity, :price))
        current_order.create_proposed_shipments if current_order.shipments.any?

        fire_event('spree.cart.add')
        fire_event('spree.order.contents_changed')
        respond_with(@order) do |format|
          format.html { redirect_to cart_path }
        end
      else
        flash[:error] = populator.errors.full_messages.join(" ")
        redirect_to :back
      end
    end

    # 20/10/13 DH: Creating a method to be called by Romancart with 'ROMANCARTXML' to indicate a completed order
    def completed

      @order = current_order
      
      posted_xml = params[:xml]

      # Remove XHTML character encoding
      xml = posted_xml.sub("<?xml version='1.0' encoding='UTF-8'?>", "")
      
      xml_doc  = Nokogiri::XML(xml)

=begin
      puts xml_doc.xpath("/romancart-transaction-data")
      puts xml_doc.xpath("/romancart-transaction-data/sales-record-fields/email").first.content
      puts xml_doc.xpath("/romancart-transaction-data/sales-record-fields/email").class
=end      

=begin
      # This then causes the browser to ask whether the user wants to resend the form data.
      #redirect_to "/api/checkouts/#{@order.number}/next?token=a05aee34ffffbac76fc642ce979c3924b148e022618c15cd" , status: :temporary_redirect
  
      # Copy of 'Spree::Api::CheckoutsController::next'
      @order.next!
      authorize! :update, @order, params[:order_token]
      respond_with(@order, :default_template => 'spree/api/orders/show', :status => 200)
      rescue StateMachine::InvalidTransition
        respond_with(@order, :default_template => 'spree/api/orders/could_not_transition', :status => 422)
=end

debugger

      #params.merge!(:checkout_complete => "true")
      if @order = current_order
        @order.state = "complete"
        @order.payment_state = "paid"
        @order.completed_at = Time.now
        @order.email = xml_doc.xpath("/romancart-transaction-data/sales-record-fields/email").first.content
        
        @order.user_id = xml_doc.xpath("/romancart-transaction-data/orderid").first.content
        @order.number = xml_doc.xpath("/romancart-transaction-data/orderid").first.content
        @order.number = Time.now.to_i.to_s
        
        # ----------------------- Billing Address ------------------------------
        @order.bill_address = orderAddress(xml_doc)
        # ----------------------- Delivery Address ------------------------------        
        #<delivery-address1/>
        if xml_doc.xpath("/romancart-transaction-data/sales-record-fields/delivery-address1").first.content.empty?
          @order.use_billing = true
        else
          @order.ship_address = orderAddress(xml_doc, "delivery-")
        end
        
        @order.save! 
      end

    end
    
    def orderAddress(xml_doc, delivery = "")
        rc_xml_country = xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}country").first.content
        rc_xml_county  = xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}county").first.content
        
        country = Spree::Country.find_by_name(rc_xml_country.titleize)
        if country.nil?
          #country = Spree::Country.create
        end
        state = Spree::State.find_by_name(rc_xml_county.titleize)
        
        order_address = Spree::Address.create!(
          :firstname => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}first-name").first.content,
          :lastname  => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}last-name").first.content,
          :address1  => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}address1").first.content,
          :address2  => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}address2").first.content,
          :city      => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}town").first.content,
          :state     => state,
          :zipcode   => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}postcode").first.content,
          :country   => country,
          :phone     => xml_doc.xpath("/romancart-transaction-data/sales-record-fields/#{delivery}phone").first.content
        )
        
    end

    def empty
    
      if @order = current_order
        @order.empty!
      end

      redirect_to spree.cart_path
    end

    def accurate_title
      @order && @order.completed? ? "#{Spree.t(:order)} #{@order.number}" : Spree.t(:shopping_cart)
    end

    def check_authorization
      session[:access_token] ||= params[:token]
      order = Spree::Order.find_by_number(params[:id]) || current_order

      if order
        authorize! :edit, order, session[:access_token]
      else
        authorize! :create, Spree::Order
      end
    end

    private

    def after_update_attributes
      coupon_result = Spree::Promo::CouponApplicator.new(@order).apply
      if coupon_result[:coupon_applied?]
        flash[:success] = coupon_result[:success] if coupon_result[:success].present?
        return false
      else
        flash[:error] = coupon_result[:error]
        respond_with(@order) { |format| format.html { render :edit } }
        return true
      end
    end
  end
end
