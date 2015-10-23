class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.boolean :default_image, default: false
      t.attachment :image
      t.references :gallery
 
      t.timestamps null: false
    end
    
    add_index :pictures, :gallery_id
  end
end
