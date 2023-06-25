class ApplicationController < ActionController::API
  protected

  def soft_authenticate
    @current_user = nil

    token = request.headers['Authorization']

    return 'Missing token' if token.nil?

    token = token.split[1]

    begin
      decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base.to_s, true, { algorithm: 'HS256' }

      user_id = decoded_token[0]['user_id']

      @current_user = User.find(user_id)

      nil
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      'Invalid token'
    rescue ActiveRecord::RecordNotFound
      'Invalid user'
    end
  end

  def authenticate
    error = soft_authenticate

    render json: { error: } unless error.nil?
  end
end
