/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
*/

$(document).ready(function() {
  var $userForm = $('#user_form');
  var $obsForm = $('#observation_form');
  var $photoForm = $('#photo_form');
  $("#observation_form").tabs({
    show: function(event, ui) {
      $(ui.panel).find('.combobox').chosen();
      $(ui.panel).find('.users').chosen({
        no_results_text: "That user was not found."
      });
    }
  });

//  $("#observation_form").tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
//	$("#observation_form li").removeClass('ui-corner-top').addClass('ui-corner-left');

  $("#observation_date").datepicker();
  $(".ice_obs").button();
  $("#ice_obs_buttons").buttonset();
  $userForm.dialog({
    modal: true,
    autoOpen: false,
    resizable: false,
    minWidth: 400,
    minHeight: 300
  });

  $("#add_user").click( function() {
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

    $('select.users').each( function(index, item) {
      $(item).append(new Option(d.firstname + " " + d.lastname, d.id));
    });
    $('select.users').chosen().trigger("liszt:updated");
    $userForm.dialog('close');
  });

  $photoForm.bind("ajax:beforeSend", function(evt, data, status, xhr) {
    var $form = $(this);
    var d = $.parsJSON(data);

    $("#attached_photos").append(data);
  });

  $photoForm.bind("ajax.success", function() {
    $()
  });

  $obsForm.bind("ajax:beforeSend", function() {
    var $dialog = $("#status_dialog");
    $dialog.dialog({
      title: "Saving, please wait...",
      modal:true,
      resizable: false,
      closable: false
    })

  });

  $obsForm.bind("ajax:success", function(evt, data, status, xhr) {
    var $dialog = $("#status_dialog");

    $dialog.dialog("close");
  })

});