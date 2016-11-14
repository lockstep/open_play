class CustomDeviseMailer < Devise::Mailer
  layout 'mailer'
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def reset_password_instructions(record, token, opts = {})
    @preheader = <<-EOS.strip_heredoc.squish
      Your password reset token is included. Please follow the instructions
      below to reset your password.
    EOS
    super
  end
end
