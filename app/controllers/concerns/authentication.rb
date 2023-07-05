module Authentication
  protected

  def authenticate
    @current_user = nil

    token = request.headers['Authorization']

    if token.nil?
      @auth_error = 'Missing token'

      return
    end

    token = token.split[1]

    begin
      decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base.to_s, true, { algorithm: 'HS256' }

      user_id = decoded_token[0]['user_id']

      @current_user = User.find(user_id)

      nil
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      @auth_error = 'Invalid token'
    rescue ActiveRecord::RecordNotFound
      @auth_error = 'Invalid user'
    end
  end

  def ensure_authenticated
    return unless @current_user.nil?

    render json: { error: @auth_error }, status: :unauthorized
  end
end
