spreeBSC adaptions to Spree
---------------------------

* gem 'spree_ajax_add_to_cart', '2.0.0'
* 'assets/javascripts/store/product.js.coffee':

1. Retrieve **data-** values sent to page from 'views/spree/products/show.html.erb' and specified in 'config/initializers/spree_bsc.rb' 

* ROMANCARTXML to '/cart/completed'

1. Parse XML with Nokogiri
2. Send API message with email of order
3. Send API message to '/api/checkouts/#{@order.number}/next?token=...'

We all like making lists
------------------------

The above header should be an H2 tag. Now, for a list of fruits:

* Red Apples
* Purple Grapes
* Green Kiwifruits

Let's get crazy:

1. This is a list item with two paragraphs. Lorem ipsum dolor
   sit amet, consectetuer adipiscing elit. Aliquam hendrerit
   mi posuere lectus.

   Vestibulum enim wisi, viverra nec, fringilla in, laoreet
   vitae, risus. Donec sit amet nisl. Aliquam semper ipsum
   sit amet velit.

2. Suspendisse id sem consectetuer libero luctus adipiscing.

What about some code **in** a list? That's insane, right?
