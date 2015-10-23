class NewsletterMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def send_newsletter_email(user, newsletter)
    @user = user
    @newsletter = newsletter
    @url = 'localhost:3000/newsletters'
    
    #used to embed inline attachments to email
    #attachments.inline['image.jpg'] = File.read('/path/to/image.jpg')
    mail(to: @user.email, subject: 'New at the Gallery')
  end
  
end
