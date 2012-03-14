$(document).ready(function() {

  $("#ice_total_concentration").blur( function(){
    if( $(this).val() === "" ) {
      $(this).val(0);
    }
    $("#tc.infotext").html("Total Concentration: " + $(this).val() + "%");
  });


});