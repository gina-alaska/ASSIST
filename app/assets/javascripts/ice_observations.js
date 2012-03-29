$(document).ready(function() {

  $("#ice_total_concentration").change( function(){

    $("#tc.infotext").html("Total Concentration: " + $(this).val() + "%");
    
    var tc = parseInt($(this).val());
    console.log("Total Coverage: ", tc);
    $(".partial_concentration option").each( function(index, item) {
      if(parseInt($(item).val()) > tc) {
        $(item).attr("disabled", true);
        $(item).removeAttr("selected");
      } else {
        $(item).removeAttr("disabled");
      }
    });
    $(".partial_concentration").chosen().trigger("liszt:updated");
  });


});