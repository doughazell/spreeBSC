<%# debugger %>

# Also populate the 'div#wrapper' area with the completed page
$('#wrapper').html('<%= escape_javascript(render(:partial => "completed")) %>')

($ '#link-to-cart').text("")

# --------------------------------------------------

# Update the link at the top of the page.
# Taken from 'spree_core-2.0.4/app/helpers/spree/base_helper.rb::link_to_cart'

#<% empty_cart = "#{Spree.t('cart')}: (#{Spree.t('empty')})" %>
#($ '#link-to-cart').html("<%= j(link_to empty_cart, spree.cart_path, :class => "cart-info empty") %>")

# --------------------------------------------------

($ '#link-to-cart').text("dum, de, dum...")

setTimeout ->
  ($ '#link-to-cart').text("")
, 2000 

