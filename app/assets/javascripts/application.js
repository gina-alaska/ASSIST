// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require select2/select2
//= require datatables-1.9.0/js/jquery.dataTables
//= require jquery-file-upload/js/vendor/jquery.ui.widget.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload.js
//= require jquery-blockUI/jquery.blockUI
//= require qtip/jquery.qtip
//= require_tree .

$.extend( $.fn.dataTableExt.oStdClasses, {
    "sSortAsc": "header headerSortDown",
    "sSortDesc": "header headerSortUp",
    "sSortable": "header"
});

$(document).ready( function() {
  $(".combobox").select2();
  $("#observation_date").datepicker();

  $('#obsList').dataTable( {
      "sDom": "<'row'<'span8'l><'span8'f>r>t<'row'<'span8'i><'span8'p>>",
      "bPaginate": true,
      "sPaginationType": "bootstrap"
  } );
  
  $("input").focus( function() {
    $(this).parent(".fields").addClass("focus");
  });
  $("input").blur( function() {
    $(this).parent(".fields").removeClass("focus");
  });


  $("#manage_observations #export_all").change( function() {
    if($(this).attr("checked") === "checked") {
      $("#manage_observations input:visible").attr("checked", "checked");
    } else {
      $("#manage_observations input").removeAttr("checked");
    }
  });

  $("#manage_observations .export").click( function(e) {
   
    e.preventDefault();
    var obsList = $("#manage_observations").find("input:checked:not(#export_all)").filter(":visible");

    var ids = [];
    var action = $(this).parent('form').attr("action") + "?";
    console.log(action);
    obsList.each( function(index, item) {
      ids.push($(item).val());
      if(index !== 0) {
        action += "&"
      }
      action += "id[]=" + $(item).val();
    });

    if(ids.length === 0) {
      alert("Please select some observations to export")
    }
    else {
      //$.rails.handleRemote($("#export form"));
      
      //action += "[" + ids.join(",") + "]";
      // $.get(action)
      // $("#export form").submit();
      document.location = action;
    }



  });
});
