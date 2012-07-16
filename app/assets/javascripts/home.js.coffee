#@author: Nourhan Azab
#@summary: a script to redirect to the correct sign in controller according to 
#the type of user selected
$(document).ready ->
  $("#log_in").click ->
  	if $("#type option:selected").text() == 'Supplier'
      target = "/suppliers/sign_in"
    if $("#type option:selected").text() == 'Customer'
      target = "/customers/sign_in"
      email= $("#supplier_email").val()
      password = $("#supplier_password").val()
      $("#customer_email").val(email)
      $("#customer_password").val(password)
    $("#sign_in_form").attr "action", target
    $("#sign_in_form").submit()
      


