# spreeBSC adaptions to Spree #

### Gem additions to Spree ###

* gem 'spree_ajax_add_to_cart', '2.0.0'

### Dynamic pricing parameters ###

Monkey-patch 'Spree::AppConfiguration' in 'config/initializers/spree_bsc.rb' to add the dynamic pricing params 
to the Spree config.

Send params to browser as hidden **data-** values in 'views/spree/products/show.html.erb'

Retrieve values in javascript that is executed when the page loads and written in CoffeeScript and interfaces 
with the DOM via jQuery in 'assets/javascripts/store/product.js.coffee'

### Curtain category tree ###

If the 'views/spree/shared/products' partial view has been called from the 'home' URL controller and the 'taxon' 
(item classification, taxonomy) has the same name as the "product" then we are selecting a curtain category.

The price entered on the '/admin' for the curtain type is "0" and is not displayed.

Lubbly, jubbly!  Simples...

### XML feedback from RomanCart ###



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
