$(document).ready( function() {
  
  var $photoForm = $('#photo_form');
  $(".photo_locations").buttonset();


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

 $(document).delegate('.delete_photo form input[type="submit"]', "click", function() {

   $(this).parents(".attached_photo").block({
     message: "Deleting"
   });

   return true;
 });
  $(document).delegate(".delete_photo form", "ajax:success", removePhoto);
  $(document).delegate(".photo_locations input", "click", updatePhotoLocation);
});


function appendPhoto(e, data) {
  console.log(data);
  var r = data.result;
  var url = data.url;
  var photo = $.get( url, function(data) {
      $("#attached_photos").append(data);
      $(".photo_locations").buttonset();
  });
  $("#photo_form").unblock();
}


function uploadPhotoError(jqXHR, textStatus, error) {

  var msg = $.parseJSON(jqXHR.responseText);
  $.each(msg, function(index, value) {
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