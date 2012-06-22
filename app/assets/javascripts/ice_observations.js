$(document).ready(function() {

  $("#observation_ice_attributes_total_concentration").on('change',function(){

    $(".partial_concentration .help-block").html("Total Concentration: " + $(this).val() + "/10");
    
    var tc = parseInt($(this).val());
    $(".partial_concentration select option").each( function(index, item) {
      if(parseInt($(item).val()) > tc) {
        $(item).attr("disabled", true);
        $(item).removeAttr("selected");
      } else {
        $(item).removeAttr("disabled");
      }
    });
    $(".partial_concentration .combobox").trigger("change");
  });


});