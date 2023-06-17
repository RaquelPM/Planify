class ApplicationController < ActionController::API
  protected

  def authenticate
    token = request.headers['Authorization']

    if token.nil?
      render json: { error: 'Missing token' }, status: :unauthorized

      return
    end

    token = token.split[1]

    begin
      decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base.to_s, true, { algorithm: 'HS256' }

      user_id = decoded_token[0]['user_id']

      @current_user = User.find(user_id)
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Invalid user' }, status: :unauthorized
    end
  end
end
