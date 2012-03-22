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
//= require chosen-fork/chosen/chosen.jquery
//=# require select2/select2
//= require datatables-1.9.0/js/jquery.dataTables
//= require jquery-file-upload/js/vendor/jquery.ui.widget.js
//= require jquery-file-upload/js/jquery.iframe-transport.js
//= require jquery-file-upload/js/jquery.fileupload.js
//= require jquery-blockUI/jquery.blockUI
//= require qtip/jquery.qtip
//= require_tree .


$(document).ready( function() {
//  $(".tip").qtip({
//    content: {
//      text: function(api) {
//        return $(this).find(".tip_content").clone();
//      }
//    },
//    position: {
//      my: 'center',
//      at: 'bottom right'
//    },
//    hide: {
//      event: 'click mouseleave',
//      fixed: true,
//      inactive: 1000
//    }
//  });

  $("input").focus( function() {
    $(this).parent(".fields").addClass("focus");
  });
  $("input").blur( function() {
    $(this).parent(".fields").removeClass("focus");
  });

});
