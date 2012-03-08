class AddChecksumToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :checksum_id, :string

  end
end
