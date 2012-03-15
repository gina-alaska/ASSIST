module ObservationsHelper
  def date obs
    obs.obs_datetime.strftime("%Y.%m.%d") || "#{Date.now.year}.#{Date.now.month}.#{Date.now.day}"
  end

  def time obs
    obs.obs_datetime.strftime("%H") || Time.now.hour
  end
end
