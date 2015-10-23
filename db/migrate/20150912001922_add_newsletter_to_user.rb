class AddNewsletterToUser < ActiveRecord::Migration
  def change
    add_column :users, :newsletter_subscriber, :boolean
    
  end
end
