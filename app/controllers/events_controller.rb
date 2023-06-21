class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]
  before_action :authenticate, only: %i[create update destroy]
  before_action :ensure_ownership, only: %i[update destroy]

  # GET /events
  def index
    @events = Event.all

    render json: @events
  end

  # GET /events/1
  def show
    render json: @event, presentation: :detailed
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    @event.creator_id = @current_user.id

    if @event.save
      render json: @event, status: :created, location: @event, presentation: :detailed
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render json: @event, presentation: :detailed
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :start_date, :finish_date, :place, :is_public)
  rescue ActionController::ParameterMissing
    {}
  end

  def ensure_ownership
    return unless @current_user.id != @event.creator.id

    render json: { error: 'Unauthorized operation' }, status: :unauthorized
  end
end

# SELECT event."*", participant."*"
# FROM event
# LEFT JOIN participant ON event.id = participant.event_id
# WHERE participant.user_id = @current_user.id
# OR event.is_public = true
