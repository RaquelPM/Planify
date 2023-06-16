class User < ApplicationRecord
  has_secure_password

  validates :name, :password, :user_name, :email, presence: true
  validates :user_name, :email, uniqueness: true

  before_save do
    self.user_name = user_name.downcase
    self.email = email.downcase
  end
end
