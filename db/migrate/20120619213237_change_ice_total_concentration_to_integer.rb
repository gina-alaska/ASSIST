class ChangeIceTotalConcentrationToInteger < ActiveRecord::Migration
  def up
    change_column :ices, :total_concentration, :integer
  end

  def down
    change_column :ices, :total_concentration, :float
  end
end
