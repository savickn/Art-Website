class Gallery < ActiveRecord::Base
  has_many :pictures, :dependent => :destroy
  
  validates :title, presence: true
  validates :description, presence: true
  validates :price, :numericality => { :greater_than_or_equal_to => 0 }
  
end
