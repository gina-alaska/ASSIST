class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
