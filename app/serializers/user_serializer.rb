class UserSerializer < ApplicationSerializer
  attributes :id, :name, :user_name, :description, :avatar_url
  detailed_attributes :email, :phone, :created_at, :updated_at
end