$ ->
  $("#add-form-link").click ->	
    $(this).text($("#just-text").text() + "t")
    $("#just-text").toggle()
    $("#form-new_machine").toggle()