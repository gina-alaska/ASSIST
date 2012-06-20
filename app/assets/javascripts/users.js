$(document).ready( function() {
  $('#user_form').on('ajax:error', function(event, xhr, status){
    $(this).find('.errors').html(xhr.responseText);
  });
  
  $('#user_form').on('ajax:beforeSend', function() {
    $(this).find('.errors').html('');
  });
  
  $('#user_form').on('ajax:success', function(event, data, status, xhr) {
    var d = $.parseJSON(data);
    
    $('select.users').each(function(index, item) {
        $(item).append(new Option(d.user.firstname + " " + d.user.lastname, d.id));
    });
    
    if(d.primary == true) {
      $("#observation_primary_observer_id").select2('val', d.id)
    } else if(d.secondary == true) {
      var selected = $("#observation_additional_observer_ids").select2('val');
      selected.push(d.id);
      $("#observation_additional_observer_ids").select2('val', selected);
    }
    
    $(this).find("input[type='text']").val("")
    $(this).modal("hide")
  });
});