class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy events created_events]
  before_action :authenticate, only: %i[update destroy events created_events]
  before_action :soft_authenticate, only: %i[index show]
  before_action :ensure_ownership, only: %i[update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user, presentation: :detailed
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, presentation: :detailed, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user, presentation: :detailed
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # GET /users/1/events
  def events
    @events = @user.events

    render json: @events
  end

  # GET /users/1/events/created
  def created_events
    @events = @user.events.where(creator_id: @user.id)

    render json: @events
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id] || params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def user_params
      return_params = params.require(:user).permit(:name, :user_name, :email, :phone, :description, :avatar_url)

      return_params.merge(params.permit(:password))
    rescue ActionController::ParameterMissing
      {}
    end

    # Only allow authenticated user to update or delete self
    def ensure_ownership
      return unless @current_user.id != @user.id

      render json: { error: 'Unauthorized operation' }, status: :unauthorized
    end
end
