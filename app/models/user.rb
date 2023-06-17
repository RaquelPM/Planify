# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  user_name       :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  phone           :string
#  description     :text
#  avatar_url      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password

  validates :name, :user_name, :email, presence: true
  validates :user_name, :email, uniqueness: { case_sensitive: false }
  validates :name, length: { minimum: 3, maximum: 150 }
  validates :user_name, length: { minimum: 3, maximum: 16 }, format: { with: /\A[a-zA-Z0-9\-_]*\Z/ }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? or !password.nil? }
  validates :phone, format: { with: /\A\(\d{2}\) \d{5}-\d{4}\Z/ }, allow_blank: true
  validates :description, length: { maximum: 2000 }, allow_blank: true

  scope :find_by_username, ->(user_name) { find_by('LOWER(user_name) = ?', user_name.downcase) }
  scope :search_by_username, ->(user_name) { where('LOWER(user_name) LIKE ?', "%#{user_name.downcase}%") }

  before_save do
    self.email = email.downcase
  end
end
