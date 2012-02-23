/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

$(document).ready(function() {
  $("#observation_form").tabs({
    show: function(event, ui) {
      $(ui.panel).find('.combobox').chosen();
      $(ui.panel).find('.users').chosen({
        no_results_text: "That user was not found."
      });
    }
  });
  $("#observation_form").tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
	$("#observation_form li").removeClass('ui-corner-top').addClass('ui-corner-left');
  $("#observation_date").datepicker();
  $("#user_form").dialog({
    modal: true,
    autoOpen: false,
    resizable: false,
    minWidth: 400,
    minHeight: 300
  });
  $("#add_user").click( function() {
    $("#user_form").dialog("open");
    return false;
  });
});