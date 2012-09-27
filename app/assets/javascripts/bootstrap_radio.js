$(document).ready( function() {
  $("body").on("click","div.btn-group[data-toggle-name]", function(e){
    e.preventDefault();
    var name = $(this).attr('data-toggle-name');
    var hidden = $('input[id="' + name + '"]');
    var form = $(this).parents('form');
    var value = $(this).find(".btn.active").attr("data-radio-value") || '';
    
    $(hidden).val(value);
    
    //Let the parent form know data has changed
    $(form).trigger("change")
  });
});