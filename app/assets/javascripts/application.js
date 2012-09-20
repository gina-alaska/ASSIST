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
//= require_tree .

$(document).ready( function() {
  $(".combobox").select2();
  $("#observation_date").datepicker();
  
  $('#obslist').dataTable( {
      "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
      // "bPaginate": true,
      // "sPaginationType": "bootstrap"
      bScrollInfinite: true,
      bScrollCollapse: true,
      sScrollY: "300px",
      bPaginate: false
  });
  
  $("input").focus( function() {
    $(this).parent(".fields").addClass("focus");
  });
  $("input").blur( function() {
    $(this).parent(".fields").removeClass("focus");
  });
  
  
  $("#export_all").change( function() {
    if($(this).attr("checked") === "checked") {
      $(".observation input:visible").attr("checked", "checked");
    } else {
      $(".observation input").removeAttr("checked");
    }
  });
  
  $("#exportAllBtn").click( function(e) {
    document.location = $(this).parents('form').attr('action');
  });
  
  $("#exportBtn").click( function(e) {
   
    e.preventDefault();
    var obsList = $(".observation input:checked:not(#export_all)").filter(":visible");
  
    var ids = [];
  
    var action = $(this).parents('form').attr("action") + "?";
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
      document.location = action;
    }
  });
  
  
  $("#import_observations").fileupload({
    dataType: 'json',
    url: $("#import_observations").attr('action'),
    acceptFileTypes: /(\.|\/)csv$/i,
    add: function(e, data) {
      data.submit();
    },
    error: function(xhr,status,error) {
      $(".errors").html(xhr.responseText);
    },
    start: function() {
      $(".errors").html("");
    }
  });
  
});
