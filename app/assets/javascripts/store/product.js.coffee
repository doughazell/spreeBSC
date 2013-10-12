# "$ ->" same as "jQuery ->" since CoffeeScript using jQuery...you beauty...feel the Javascript leverage
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
        
  radios = ($ '#product-variants input[type="radio"]')

  if radios.length > 0
    Spree.showVariantImages ($ '#product-variants input[type="radio"]').eq(0).attr('value')
    Spree.updateVariantPrice radios.first()

  Spree.addImageHandlers()

  radios.click (event) ->
    Spree.showVariantImages @value
    Spree.updateVariantPrice ($ this)
    ($ '.doug.text').text(Spree.getCurrentMultiple)
    
  ###
  --- BSC dynamic pricing ---
  ###

  Spree.getCurrentMultiple = ->
    current_multiple = ($ '#product-variants input[type="radio"]:checked').data('heading')
    
    hyphened_heading = current_multiple.replace(/\ /g, '-')
    hyphened_heading += "-multiple"
    # Implicit return of last value
    current_multiple_val = ($ '#bsc-pricing').data(hyphened_heading)    

  # ------------------ Params (from initializer file) stored in web page via 'data-' attribute and used by jQuery --------------
  # Following numbers are in 'cm'
  returns_addition   = ($ '#bsc-pricing').data('returns-addition')
  side_hems_addition = ($ '#bsc-pricing').data('side-hems-addition')
  turnings_addition  = ($ '#bsc-pricing').data('turnings-addition')

  fabric_width = ($ '#bsc-pricing').data('fabric-width')

  # Following numbers are in '£/m'  
  cotton_lining   = ($ '#bsc-pricing').data('cotton-lining')
  blackout_lining = ($ '#bsc-pricing').data('blackout-lining')
  thermal_lining  = ($ '#bsc-pricing').data('thermal-lining')    

  cotton_lining_labour   = ($ '#bsc-pricing').data('cotton-lining-labour')
  blackout_lining_labour = ($ '#bsc-pricing').data('blackout-lining-labour')
  thermal_lining_labour  = ($ '#bsc-pricing').data('thermal-lining-labour')   
  # ----------------------------------------------------------------------------------------------------------------------------- 
  
  # This value will be assigned when the 'width' field is assigned (so needs to be declared above the function definition)
  number_of_widths = 0
  
  # 'jQuery' event binding in CoffeeScript
  # 8/10/13 DH: I feel I'm finally on home ground...ye haaa! :) That's only taken me 8 years since cutting the boot loader code...
  $(document).on('blur', '#width', ( ->
    width = (Number) @value
    width += returns_addition
    
    multiple = Spree.getCurrentMultiple()
    required_width = width * multiple
    required_width += side_hems_addition
    # We always need to round up, NOT TO NEAREST INT, so 2.1 needs to be 3 not 2!
    number_of_widths = Math.ceil(required_width / fabric_width)
        
#    ($ '.doug.text').text(($ '#product-variants input[type="radio"]:checked').attr('data-price')) 
#    ($ '.doug.text').text(($ '#product-variants input[type="radio"]:checked').data('price'))    

    ($ '.doug.text').text(number_of_widths)

  ))
  
  
  $(document).on('blur', '#drop', ( ->
    drop = (Number) @value
    cutting_len = drop + turnings_addition
    required_fabric = cutting_len * number_of_widths

    ($ '.doug.text').text(required_fabric)

  ))
