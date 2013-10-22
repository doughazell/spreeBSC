
# Also populate the 'div#wrapper' area with the completed page
$('#wrapper').html('<%= escape_javascript(render(:partial => "completed")) %>')

($ '#link-to-cart').text("")

# --------------------------------------------------

#($ '#link-to-cart').text("dum, de, dum...")

# Update the link at the top of the page
#($ '#link-to-cart').html("<%= j(link_to_cart) %>")

#setTimeout ->
#  ($ '#link-to-cart').text("")
#, 3000 

