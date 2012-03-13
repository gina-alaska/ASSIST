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
//= require jquery-ui
//=# require jquery.remotipart
//= require chosen/chosen/chosen.jquery
//= require datatables-1.9.0/js/jquery.dataTables
//= require jquery-file-upload/js/vendor/jquery.ui.widget.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload.js
//= require jquery-blockUI/jquery.blockUI
//= require qtip/jquery.qtip
//= require_tree .


$(document).ready( function() {
  $(".tooltip").qtip({
    content: {
      text: function(api) {
        return $(this).find(".content").clone();
      }
    }
  });
  $(".tooltip").button({
    icons: {
      primary: "ui-icon-help"
    },
    text: false
  });
  $(".tooltip").click( function() {
    var url = $(this).find(".detail");
    if( url.length != 0 ) {
      var content = $(url).attr("href");
      $.get(content, function(data, status, jqXHR) {
        $("#lookup_details").dialog();
        $("#lookup_details").html(data);
      });
    }
  });

});