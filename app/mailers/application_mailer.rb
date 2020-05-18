class ApplicationMailer < ActionMailer::Base
  default from: Settings.user_mailer.email
  layout "mailer"
end
