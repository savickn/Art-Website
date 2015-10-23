class Newsletter < ActiveRecord::Base
  
  validates :title, presence: true
  validates :content, presence: true, length: {minimum: 10}
  
  scope :published, -> {where(published: true)}
  scope :unpublished, -> {where(published: false)}
  scope :unemailed, -> {where(emailed: false)}
  scope :emailed, -> {where(emailed: true)}
  
  def self.publish_recent_newsletters
    @users = User.subscriber
    @newsletters = Newsletter.published.unemailed
    
    @newsletters.each do |newsletter|
      @users.each do |user|
        EmailWorker.perform_async(user.id, newsletter.id)
      end      
    end
  end
end
