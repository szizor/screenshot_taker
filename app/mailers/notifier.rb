class Notifier < ActionMailer::Base
  default :from => "Placeit by Breezi <noreply@placeit.net>"

  def purchase_confirmation(email, path)
    @subject = 'Purchase confirmation'
    @title = 'Image'
    full_path = Rails.public_path + path
    attachments['breezi_placeit.png'] = File.read(full_path)
    mail(:to => email, :subject => @subject)
  end
end
