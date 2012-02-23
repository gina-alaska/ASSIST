/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/

$(document).ready(function() {
  $("#observation_form").tabs({
    show: function(event, ui) {
      $(ui.panel).find('.combobox').chosen();
    }
  });
  $("#observation_form").tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
	$("#observation_form li").removeClass('ui-corner-top').addClass('ui-corner-left');
  $("#observation_date").datepicker();
});