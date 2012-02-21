class CreateBiotaTypes < ActiveRecord::Migration
  def change
    create_table :biota_types do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end
