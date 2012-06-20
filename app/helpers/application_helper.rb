module ApplicationHelper
  def active_wizard? step
    wizard_path == wizard_path(step)
  end

end
