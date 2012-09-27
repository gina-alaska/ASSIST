$(document).ready( function() {
  $("body").on('click', "#upload_photo_btn", function(){
    $("#photo_data").trigger('click').fileupload({
      dataType: 'script',
      url: $(this).attr('action'),
      add: function(e, data) {
        data.submit();
      },
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
  });

  $("body").on("change", ".new_photo", function(){
    $(this).fileupload({
      dataType: 'script',
      url: $(this).attr('action'),
      add: function(e, data) {
        data.submit();
      },
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
  });
  
  $("body").on('ajax:success', "#attached_photos .delete_photo", function() {
    $(this).parents(".row:first").fadeOut('fast', function() {
      $(this).remove();
    });
  });
});
