# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  avatar_url      :string
#  description     :text
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  phone           :string
#  user_name       :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email      (email) UNIQUE
#  index_users_on_user_name  (user_name) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_many :participations
  has_many :events, through: :participations

  validates :name, :user_name, :email, presence: true
  validates :name, length: { minimum: 3, maximum: 80 }
  validates :user_name, length: { minimum: 3, maximum: 16 }, format: { with: /\A[a-zA-Z][a-zA-Z0-9\-_]*\Z/ }, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: -> { new_record? or !password.nil? }
  validates :phone, format: { with: /\A\(\d{2}\) \d{5}-\d{4}\Z/ }, allow_blank: true
  validates :description, length: { maximum: 2000 }, allow_blank: true

  scope :find_by_username, ->(user_name) { find_by('LOWER(user_name) = ?', user_name.downcase) }
  scope :search_by_username, ->(user_name) { where('LOWER(user_name) LIKE ?', "%#{user_name.downcase}%") }

  before_save do
    self.email = email&.downcase
  end

  private :participations, :participations= 
end