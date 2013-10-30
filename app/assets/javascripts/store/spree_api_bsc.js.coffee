$ ->
  $(document).on('click', '#complete_order_button', ( ->
    order_number = ($ '#complete_order_button').data('order-number')
    alert "'complete order' for " + order_number
    
    $.ajax
      url: '/api/checkouts/' + order_number + '/next?token=a05aee34ffffbac76fc642ce979c3924b148e022618c15cd'
      dataType: 'json'
      type: 'PUT'
      
      success: (data, textStatus, jqHXR) ->
        ($ '#api-response').text(data.state)
        console.log data
      
      error: (jqXHR, textStatus, errorThrown) ->
        ($ '#api-response').text(jqXHR.responseText)
        alert jqXHR.responseText
      
      complete: (jqXHR, textStatus) ->
        #alert textStatus
              
  ))
  # ---
  

# /api/checkouts/R515643866
# ?token=a05aee34ffffbac76fc642ce979c3924b148e022618c15cd

