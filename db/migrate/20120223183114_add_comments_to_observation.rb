class AddCommentsToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :comments, :text

    add_column :observations, :additional_comments, :text

  end
end
