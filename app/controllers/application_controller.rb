class ApplicationController < ActionController::API
  before_action :authenticate

  protected

  def authenticate
    @current_user = nil

    token = request.headers['Authorization']

    if token.nil?
      @auth_error = 'Missing token'
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
    if @current_user.nil?
      render json: { error: @auth_error }
    else
  end

  def paginate(class_name, filters: {})
    model = class_name.to_s.constantize

    page = params[:page]&.to_i || 1
    limit = params[:limit]&.to_i || 50
    sort_by = params[:sort_by] || 'updated_at'
    order_by = params[:order_by] || params[:sort_by] ? 'ASC' : 'DESC'

    content = model.pagination(filters:, page:, limit:, sort_by:, order_by:)

    total = model.count

    json = {}

    json[:content] = ActiveModelSerializers::SerializableResource.new(content)

    json[:pagination] = {
      current_page: page,
      total_pages: (total / limit.to_f).ceil,
      total_elements: total
    }

    render json:
  end
end
