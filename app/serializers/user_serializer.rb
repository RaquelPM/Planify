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
class UserSerializer < ApplicationSerializer
  attributes :id, :name, :user_name, :description, :avatar_url
  detailed_attributes :email, :phone, :created_at, :updated_at
end
