class AddNoteToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :note, :string

  end
end
