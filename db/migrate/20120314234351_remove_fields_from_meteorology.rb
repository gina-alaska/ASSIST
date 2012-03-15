class RemoveFieldsFromMeteorology < ActiveRecord::Migration
  def up
    Meteorology.all.each do |m|
      m.clouds <<  Cloud.new(:cloud_lookup_id => m.cloud_lookup_id,
                                :height => m.cloud_height,
                                :cover => m.cloud_cover,
                                :cloud_type => "high" )
      m.save!
    end
    remove_column :meteorologies, :cloud_height
    remove_column :meteorologies, :cloud_cover
    remove_column :meteorologies, :cloud_lookup_id
  end

  def down
    add_column :meteorologies, :cloud_height, :integer
    add_column :meteorologies, :cloud_cover, :float
    add_column :meteorologies, :cloud_lookup_id, :integer

    Meteorology.all.each do |m|
      m.cloud_height = m.clouds.high.height
      m.cloud_cover = m.clouds.high.cover
      m.cloud_lookup_id = m.clouds.high.cloud_lookup_id
      m.save!
    end
  end
end
