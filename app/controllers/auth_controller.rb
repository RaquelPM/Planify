class AuthController < ApplicationController
  # POST /auth/login
  def login
    # @type [String]
    email = params[:email]
    # @type [String]
    password = params[:password]

    if email.nil? or password.nil?
      render json: { error: 'Missing email or password' }, status: :bad_request 
    
      return
    end

    email.downcase!

    begin
      user = User.find_by(email: email)

      if !user.nil? and user.authenticate(password)
        payload = { user_id: user.id, exp: Time.now.to_i + (24 * 60 * 60) }

        token = JWT.encode payload, Rails.application.secrets.secret_key_base.to_s, 'HS256'

        render json: { token: token }
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end