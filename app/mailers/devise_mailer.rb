class DeviseMailer < Devise::Mailer
  helper :application
    include Devise::Controllers::UrlHelpers
    default from: "thalamalaakhil@gmail.com"
    layout "mailer"
  
    def welcome_email(user)
      @user = user
      mail(to: @user.email, subject: "Welcome to My SaaS App 🎉")
    end

    def confirmation_instructions(record, token, opts = {})
       @token = token
       @resource = record
       mail(to: record.email, subject: "Confirm your account 🚀")
    end
end