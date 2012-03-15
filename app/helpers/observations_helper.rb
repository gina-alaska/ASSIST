module ObservationsHelper
  def date obs
    now = DateTime.now
    obs.obs_datetime.try(:strftime,"%Y.%m.%d") || "#{now.year}.#{now.month}.#{now.day}"
  end

  def time obs
    obs.obs_datetime.try(:strftime, "%H") || Time.now.hour
  end
end
