$(document).ready(function() {

  $("body").on("ajax:success", "#new_comment", appendComment );
  $("body").on("ajax:error", "#new_comment", function(){
  });
  $("body").on("ajax:complete", "#new_comment", function() {
    $(this).parent(".modal").modal('hide');
  });
  $("body").on('ajax:success',"#attached_comments .close", function() {
    console.log("DOOM")
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