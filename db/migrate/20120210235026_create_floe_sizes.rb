class CreateFloeSizes < ActiveRecord::Migration
  def change
    create_table :floe_sizes do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
