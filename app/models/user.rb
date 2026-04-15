class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  enum role: { owner: 0, tenant: 1 }

  has_one :tenant, dependent: :destroy

  after_create :send_welcome_email
  after_create :generate_and_send_otp
  after_create_commit :ensure_tenant_exists

  def generate_and_send_otp
    generate_otp!
    save!
    UserMailer.send_otp(self).deliver_later
  end

  def generate_otp!
    self.otp_code = rand(100000..999999).to_s
    self.otp_sent_at = Time.current
  end

  def otp_valid?(code)
    return false if otp_sent_at.nil?
    otp_code == code && otp_sent_at > 10.minutes.ago
  end

  def mark_otp_verified!
    update!(
      otp_verified_at: Time.current,
      otp_code: nil,
      otp_sent_at: nil
    )
  end

  private

  def send_welcome_email
    DeviseMailer.welcome_email(self).deliver_later
  end

  def ensure_tenant_exists
    return unless tenant?

    Tenant.find_or_create_by!(user: self) do |t|
      t.name = email.split("@").first.capitalize
      t.email = email
    end
  end
end