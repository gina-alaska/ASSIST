class CreateProgressTypes < ActiveRecord::Migration
  def change
    create_table :progress_types do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
