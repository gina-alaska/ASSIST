module ObservationsHelper
  def date obs
    now = DateTime.now
    obs.obs_datetime.try(:strftime,"%Y.%m.%d") || "#{now.year}.#{now.month}.#{now.day}"
  end

  def time obs
    obs.obs_datetime.try(:strftime, "%H") || Time.now.hour
  end

  def to_dms coord
    coord = coord.to_f
    deg = coord < 0 ? coord.ceil : coord.floor

    min = ((coord - deg).abs * 60.0).floor
    sec = (((coord - deg).abs * 60.0) % 1) * 60.0
    "#{deg} #{min + (sec/100.0).round(2)}"
  end
end
