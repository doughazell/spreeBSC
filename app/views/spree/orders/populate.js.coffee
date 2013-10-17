($ '#price-text').text('You beauty...')

# 17/10/13 DH: This just populates the "Cart: ..." link on the Products Show page via AJAX.
#              The cart itself is a DB table on the server which then is used by Orders Edit
($ '#link-to-cart').html("<%= j(link_to_cart) %>")