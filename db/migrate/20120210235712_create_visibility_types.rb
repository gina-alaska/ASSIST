class CreateVisibilityTypes < ActiveRecord::Migration
  def change
    create_table :visibility_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
