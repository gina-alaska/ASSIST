module MeltPondsHelper
  def boolean_button_state(value, target)
    value == target ? 'active' : ''
  end

end
