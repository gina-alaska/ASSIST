module ObservationsHelper
  def date obs
    now = DateTime.now
    obs.obs_datetime.try(:strftime,"%Y.%m.%d") || "#{now.year}.#{now.month}.#{now.day}"
  end

  def hour obs
    obs.obs_datetime.try(:strftime, "%H").to_i || Time.now.hour.to_i
  end
  
  def minute obs
    obs.obs_datetime.try(:strftime, "%M").to_i || Time.now.minute.to_i
  end

  def to_dms coord
    coord = coord.to_f
    deg = coord < 0 ? coord.ceil : coord.floor

    min = ((coord - deg).abs * 60.0).floor
    sec = ((((coord - deg).abs * 60.0) % 1) * 60.0).round
    "#{deg} #{min} #{sec}"
  end
  
  def lookup_url_helper item
    link_to "See Examples", lookup_url(item), target: '_blank'
  end
  
  def first_page? 
    wizard_path == wizard_path(:general)
  end
  
  def last_page?
    wizard_path == wizard_path(:comments)
  end
  
  def partial_concentration_options observation, concentration
    options = (0..10).to_a
    disabled = options.select{|a| a > concentration} unless concentration.nil?
    disabled ||= []
    options_for_select(options, selected: observation.partial_concentration, disabled: disabled)
  end
  
  def total_concentration_options observation
    options_for_select((0..10).to_a, selected: observation.total_concentration)
  end
  
  def options_for_percent selected, disabled=nil, range=nil
    range ||= (0..10).to_a
    options_for_select(range, {selected: selected, disabled: disabled})
  end
  
  def photo_upload_fields(f)
    photo = Photo.new(name: "/placeholder_photo/")
    fields = f.fields_for(:photos, photo, child_index: 'uploaded_photo') do |form|
      render 'photos/photo_fields', photo: photo, form: form
    end
    fields.gsub("\n","")
  end
  
  def ship_power_options(p)
    options_for_select([["0", 0],["1/4", 1],["1/2", 2],["3/4", 3],["Full", 4]], p)
  end
end
