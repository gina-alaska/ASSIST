/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
*/

$(document).ready(function() {

  var $userForm = $('#user_form');
  var $obsForm = $('#observation_form');
  var $photoForm = $('#photo_form');
  $obsForm.tabs({
    show: function(event, ui) {
      $(ui.panel).find('.combobox:visible').chosen();
      $(ui.panel).find('.users').chosen({
        no_results_text: "That user was not found."
      });
    }
  });

  $(".photo_locations").buttonset();
  $("#ice_obs_buttons").buttonset();
  $("#ice_obs_buttons input").click( function() {
    var target = $(this).attr('value');
    $("#ice .selected").hide().removeClass('selected');
    $(target).addClass('selected').show(0, function() {
      $(this).find('.combobox').chosen();
      console.log($(this).find('.combobox'));
    });
  });
  $(".ice_obs").hide();
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

  $photoForm.fileupload({
    dataType: 'json',
    url: $photoForm.attr('action'),
    add: function(e, data) {
      $(this).block({
        message: "Please Wait..."
      });
      data.submit();
    },
    done: appendPhoto,
    error: uploadPhotoError
  });
/*
  $obsForm.bind("ajax:beforeSend", function() {
    var $dialog = $("#status_dialog");
    $dialog.dialog({
      title: "Saving, please wait...",
      modal:true,
      resizable: false,
      closable: false
    })

  });
/*
  $obsForm.bind("ajax:success", function(evt, data, status, xhr) {
    var $dialog = $("#status_dialog");

    $dialog.dialog("close");
  });
*/
 $(document).delegate('.delete_photo form input[type="submit"]', "click", function() {

   $(this).parents(".attached_photo").block({
     message: "Deleting"
   });

   return true;
 });
  $(document).delegate(".delete_photo form", "ajax:success", removePhoto);
  $(document).delegate(".photo_locations input", "click", updatePhotoLocation)
});


function appendPhoto(e, data) {
  var r = data.result;
  var url = "/observations/" + r.observation_id + "/photos/" + r.id;
  var photo = $.get( url, function(data) {
      $("#attached_photos").append(data);
      $(".photo_locations").buttonset();
  });
  $("#photo_form").unblock();
}

function uploadPhotoError(jqXHR, textStatus, error) {

  var msg = $.parseJSON(jqXHR.responseText);
  console.log(msg);
  $.each(msg.name, function(index, value) {
    $.growlUI(value);
  });
  $("#photo_form").unblock();
}

function removePhoto() {
  $(this).parents(".attached_photo").remove();
  $.growlUI('', "Photo deleted");
}

function updatePhotoLocation() {
  var form = $(this).parents('form');
  var url =$(form).attr('action');
  $.post( url, $(form).serialize(), function() {
    $.growlUI(('', 'Saved'))
  });

}