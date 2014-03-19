class ChangeWindDirectionToInteger < ActiveRecord::Migration
  def up
    change_column :meteorologies, :wind_direction, :integer
  end

  def down
    change_column :meteorologies, :wind_direction, :string
  end
end
