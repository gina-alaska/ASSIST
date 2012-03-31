$(document).ready( function() {
  var $userForm = $('#user_form');

  $userForm.dialog({
      modal: true,
      autoOpen: false,
      resizable: false,
      minWidth: 400,
      minHeight: 200
  });

  $("#user_form input[type='submit']").button();

  $("#adduser").click( function() {
    $userForm.dialog("open");
    return false;
  });


  $userForm.bind("ajax:error", function( e, xhr, status ) {
    var $form = $(this);
    var errors;
    var errorText = "";
    try {
      errors = $.parseJSON(xhr.responseText)
    } catch(err) {
      errors = { message: "Please reload the page and try again" }
    }

    for( error in errors ) {
      errorText += "<div class=\"error\">"+ error + ": " + errors[error] + "</div>"
    }
    $form.find('div.errors').html(errorText);
  });

  $userForm.bind("ajax:success", function(evt, data, status, xhr) {
    var $form = $(this);
    var d = $.parseJSON(data);
    console.log(d);

    $('select.users').each( function(index, item) {
      $(item).append(new Option(d.user.firstname + " " + d.user.lastname, d.id));
    });
    if(d.primary == true) {
      $("#observation_primary_observer_id option:selected").removeAttr("selected");
      $("#observation_primary_observer_id option[value='"+d.id+"']").attr("selected", true);
    }
    $('select.users').chosen().trigger("liszt:updated");

    $userForm.dialog('close');
  });
});