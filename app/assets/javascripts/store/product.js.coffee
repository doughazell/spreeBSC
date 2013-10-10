# jQuery ->
$ ->
  exports = this
  
  Spree.addImageHandlers = ->
    thumbnails = ($ '#product-images ul.thumbnails')
    ($ '#main-image').data 'selectedThumb', ($ '#main-image img').attr('src')
    thumbnails.find('li').eq(0).addClass 'selected'
    thumbnails.find('a').on 'click', (event) ->
      ($ '#main-image').data 'selectedThumb', ($ event.currentTarget).attr('href')
      ($ '#main-image').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
      ($ this).mouseout ->
        thumbnails.find('li').removeClass 'selected'
        ($ event.currentTarget).parent('li').addClass 'selected'
      false

    thumbnails.find('li').on 'mouseenter', (event) ->
      ($ '#main-image img').attr 'src', ($ event.currentTarget).find('a').attr('href')

    thumbnails.find('li').on 'mouseleave', (event) ->
      ($ '#main-image img').attr 'src', ($ '#main-image').data('selectedThumb')

  Spree.showVariantImages = (variantId) ->
    ($ 'li.vtmb').hide()
    ($ 'li.tmb-' + variantId).show()
    currentThumb = ($ '#' + ($ '#main-image').data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = ($ ($ 'ul.thumbnails li:visible.vtmb').eq(0))
      thumb = ($ ($ 'ul.thumbnails li:visible').eq(0)) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')
      ($ 'ul.thumbnails li').removeClass 'selected'
      thumb.addClass 'selected'
      ($ '#main-image img').attr 'src', newImg
      ($ '#main-image').data 'selectedThumb', newImg
      ($ '#main-image').data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPrice = (variant) ->
    variantPrice = variant.data('price')
    ($ '.price.selling').text(variantPrice) if variantPrice
    
    # 8/10/13 DH: Now keep the current variant price for the dynamic pricing
    exports.variantPrice = variantPrice
    
  radios = ($ '#product-variants input[type="radio"]')
  
#  radios_current =  ($ '#product-variants input[type="radio"]:checked').val()
  radios_current =  ($ '#product-variants input[type="radio"]:checked').attr('data-price')

  if radios.length > 0
    Spree.showVariantImages ($ '#product-variants input[type="radio"]').eq(0).attr('value')
    Spree.updateVariantPrice radios.first()

  Spree.addImageHandlers()

  radios.click (event) ->
    Spree.showVariantImages @value
    Spree.updateVariantPrice ($ this)
    #($ '.doug.text').text( ($ this).data('price') )
    
  ###
  --- BSC dynamic pricing ---
  ###

  width_field = ($ '#width')
  
#  ($ '.doug.text').text(width_field.attr('value'))
  ($ '.doug.text').text(radios_current)
  
#  setTimeout -> 
#    ($ '.doug.text').text("dum, de, dum...") 
#   , 1000 
  
  
#  width_field.click (event) ->
#    ($ '.doug.text').text(@value)
#    alert "Getting close..."
  
  # 'jQuery' event binding in CoffeeScript
  # 8/10/13 DH: I feel I'm finally on home ground...ye haaa! :) That's only taken me 8 years since cutting the boot loader code...
  $(document).on('blur', '#width', ( ->
    width = (Number) @value
    #width +=  Spree::Config[:returns_addition]
    width += 12
    
    
#    ($ '.doug.text').text(exports.variantPrice)
#    ($ '.doug.text').text(($ '#product-variants input[type="radio"]:checked').attr('data-price'))    
    ($ '.doug.text').text(width)
  ))
  