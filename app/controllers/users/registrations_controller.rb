class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      resource.generate_otp!
      resource.save!

      UserMailer.send_otp(resource).deliver_later

      redirect_to otp_path(email: resource.email)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end