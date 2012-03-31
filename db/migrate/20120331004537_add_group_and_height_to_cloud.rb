class AddGroupAndHeightToCloud < ActiveRecord::Migration
  def change
    add_column :cloud_lookups, :group, :string

    add_column :cloud_lookups, :height, :string

  end
end
