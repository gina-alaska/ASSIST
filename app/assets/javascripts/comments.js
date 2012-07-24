$(document).ready(function() {

  $("#new_comment").on("ajax:success", appendComment );
  $("#new_comment").on("ajax:error", function(){
  });
  $("#new_comment").on("ajax:complete", function() {
    $(this).parent(".modal").modal('hide');
  });
  $("#attached_comments").on('ajax:success',".close", function() {
    $(this).parents(".comment:first").fadeOut('fast', function() {
      $(this).remove();
    });
  });
});



function appendComment(e, data) {
  var url = data.url;
  var comment = $.get( url, function(data) {
    $("#attached_comments").append(data);
  });
  $("#comment_data").val($("#comment_data").html());
}