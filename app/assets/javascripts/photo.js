$(document).ready( function() {
  var $photoForm = $('#new_photo');

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
    error: function(xhr,status,error) {
      console.log(arguments);
      $(".errors").html(xhr.responseText);
    },
    complete: function() {
      $("#new_photo").unblock();
    },
    start: function() {
      $(".errors").html("");
    }
  });

  $("#attached_photos").on('ajax:success',".delete_photo", function() {
    $(this).parents(".row:first").fadeOut('fast', function() {
      $(this).remove();
    });
  });
});


function appendPhoto(e, data) {
  var r = data.result;
  var url = r.url;
  var photo = $.get( url, function(data) {
    $("#attached_photos").append(data);
  });
  //$("#new_photo").unblock();
}