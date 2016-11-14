class ApplicationMailer < ActionMailer::Base
  default from: 'OpenPlay Notifier <no-reply@openplay.io>'
  layout 'mailer'
end
