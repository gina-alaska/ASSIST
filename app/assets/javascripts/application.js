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
//= require datatables/media/js/jquery.dataTables.js
//= require jquery-file-upload/js/vendor/jquery.ui.widget.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload.js
//= require select2/select2
//= require jquery_nested_form
//= require_tree .

$(document).ready( function() {
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
  
  $("#export_all").change( function() {
    if($(this).attr("checked") === "checked") {
      $(".observation input:visible:enabled").attr("checked", "checked");
    } else {
      $(".observation input").removeAttr("checked");
    }
  });
  
  $("#exportAllBtn").click( function(e) {
    e.preventDefault();
    if(confirm("This will only export valid observations. Proceed?")) {
      document.location = $(this).parents('form').attr('action');
    }
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
  
  $("body").on("ajax:beforeSend", "#observation_form", function(xhr,s) {
    $(".spinner").removeClass("hide");
  });
  $("body").on("ajax:complete", "#observation_form", function(xhr, s){
    $(".spinner").addClass("hide");
  });

  $("#import_observations").fileupload({
    // dataType: 'html',
    url: $("#import_observations").attr('action'),
    acceptFileTypes: /(\.|\/)csv$/i,
    add: function(e, data) {
      console.log("Added a file")
      $('#upload_status').show();
      
      data.context = $('<div class="progress" />').appendTo($('#upload_messages'))
      $('<div class="bar" style="width:0%" />').text('Uploading').appendTo($(data.context));

      data.submit();
    },
    done: function (e, data) {
      data.context.find('.bar').text('Finished');
      data.context.find('.bar').addClass('bar-success');
    },
    fail: function(e, data) {
      data.context.find('.bar').text('Failed');
      data.context.find('.bar').addClass('bar-danger');
      $("#errors").html(data.jqXHR.responseText);
    },
    progress: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      data.context.find('.bar').css(
        'width',
        progress + '%'
      );
    }
  });
  
});




