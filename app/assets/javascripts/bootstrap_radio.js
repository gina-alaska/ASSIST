jQuery(function($) {
  $('div.btn-group[data-toggle-name=*]').each(function(){
    var group   = $(this);
    var form    = group.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[id="' + name + '"]', form);
    $('button', group).each(function(){
      var button = $(this);
      button.live('click', function(e){
        e.preventDefault();
        form.trigger('change');
        hidden.val($(this).attr('data-radio-value'));
      });
      // if(button.val() == hidden.val()) {
      //   button.addClass('active');
      // }
      if(form.attr('data-remote') == 'true') {
        form.submit();
      }
    });
  });
});