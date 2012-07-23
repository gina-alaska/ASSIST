$(document).ready( function() {
  var $photoForm = $('#new_photo');

  $("#attached_photos").on('change', ".edit_photo input", function(el){
    $(el.target).submit();
  });
  
  $("#attached_photos").on("ajax:beforeSend", ".edit_photo", function(el) {
    $(this).find('.label-success').addClass('hide');
    $(this).find('.label-warning').removeClass('hide');      
  })
  $("#attached_photos").on("ajax:success", ".edit_photo", function(el) {
    $(this).find('.label-warning').addClass('hide');
    $(this).find('.label-success').removeClass('hide').fadeOut('slow', function() {
      $(this).addClass('hide').removeAttr('style');
    });  
  });

  $photoForm.fileupload({
    dataType: 'json',
    url: $photoForm.attr('action'),
    add: function(e, data) {
      console.log(data);
      data.submit();
    },
    done: appendPhoto,
    error: function(xhr,status,error) {
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