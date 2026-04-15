class OtpController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :verify]

  def new
  end

  def verify
    user = User.find_by(email: params[:email])

    if user&.otp_valid?(params[:otp])
      user.mark_otp_verified!
      sign_in(user)
      redirect_to dashboard_path, notice: "OTP verified successfully"
    else
      redirect_to otp_path(email: params[:email]), alert: "Invalid OTP"
    end
  end
end
