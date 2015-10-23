class Picture < ActiveRecord::Base
  belongs_to :gallery
  has_attached_file :image, styles: { small: "64x64", med: "200x200", large: "1920x1080" }
  
  validates_attachment :image, :presence => true, 
                       :content_type => {:content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]},
                       size: { less_than: 5.megabytes }
  validates :gallery_id, :presence => true
  
  scope :default, -> {where(default_image: true)}
  
end
