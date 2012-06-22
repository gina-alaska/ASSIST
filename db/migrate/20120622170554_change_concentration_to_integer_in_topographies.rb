class ChangeConcentrationToIntegerInTopographies < ActiveRecord::Migration
  def up
    change_column :topographies, :concentration, :integer
  end

  def down
    change_column :topographies, :concentration, :float
  end
end
