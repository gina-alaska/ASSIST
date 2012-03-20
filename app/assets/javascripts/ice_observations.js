$(document).ready(function() {

  $("#ice_total_concentration").blur( function(){
    if( $(this).val() === "" ) {
      $(this).val(0);
    }
    $("#tc.infotext").html("Total Concentration: " + $(this).val() + "%");
  });

  $(".iceobs_column:not('.active') input").prop("disabled", true);

  $(".iceobs_column").click( function() {
    $(".iceobs_column.active input").prop("disabled", true);
    $(".iceobs_column").removeClass("active");
    $(this).addClass("active");
    $(this).find("input").prop("disabled", false);
  });

  $(".iceobs_column input").change( function(e) {
    console.log( $(this).attr("value"));
  });

});