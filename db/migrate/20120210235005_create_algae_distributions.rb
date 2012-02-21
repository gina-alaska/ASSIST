class CreateAlgaeDistributions < ActiveRecord::Migration
  def change
    create_table :algae_distributions do |t|
      t.string :name
      t.integer :code

      t.timestamps
    end
  end
end
