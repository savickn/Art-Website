class AddPublishedAndEmailedToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :published, :boolean, default: false
    add_column :newsletters, :emailed, :boolean, default: false
  end
end
