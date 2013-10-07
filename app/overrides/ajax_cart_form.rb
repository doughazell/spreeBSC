Deface::Override.new(:virtual_path => 'spree/products/_cart_form',
                     :name => 'my_remote_cart_form',
                     :replace => "code[erb-loud]:contains('form_for :order, :url => populate_orders_path, :remote => true do |f|')",
                     :erb => "<%= form_for :order, :url => populate_orders_path do |f| %>",
                     :sequence => {:before => 'remote_cart_form'})
                     #:sequence => {:after => 'remote_cart_form'})

# :erb => "<%= form_for :order, :url => populate_orders_path, :remote => true do |f| %>",

# 28/8/13 DH: If it's ':before =>' the 'spree_ajax_add_to_cart' gem Deface, then the ':remote => true' will not have been added 
#             and hence this will DO NOTHING!