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

  validates :name, :password, :user_name, :email, presence: true
  validates :user_name, :email, uniqueness: true

  before_save do
    self.user_name = user_name.downcase
    self.email = email.downcase
  end
end
