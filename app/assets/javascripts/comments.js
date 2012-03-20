$(document).ready(function() {
  $("#add_comment").button();
  $("#comments_form").bind("ajax:beforeSend", function(e) {
    $(this).block();
    e.preventDefault();
  });
  $("#comments_form").bind("ajax:success", appendComment );
});



function appendComment(e, data) {
  var url = "/observations/" + data.observation_id + "/comments/" + data.id;
  var comment = $.get( url, function(data) {
    $("#obs_comments").append(data);
  });
  $("#comments_form textarea").val("");
  $("#comments_form").unblock();
}