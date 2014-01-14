class AddBottomTypeToMeltPond < ActiveRecord::Migration
  def change
    add_column :melt_ponds, :bottom_type_lookup_id, :integer
  end
end
