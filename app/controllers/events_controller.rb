class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy join leave participants]
  before_action :authenticate, only: %i[create update destroy join leave]
  before_action :soft_authenticate, only: %i[index show participants]
  before_action :ensure_ownership, only: %i[update destroy]

  # GET /events
  def index
    @events = Event.list(@current_user&.id)

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
      Participant.create(user_id: @current_user.id, event_id: @event.id)

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

  # POST /events/1/join
  def join
    @participant = Participant.new(user_id: @current_user.id, event_id: @event.id)

    if @participant.save
      render json: @event, presentation: :detailed
    else
      render json: @participant.errors, status: :unprocessable_entity
    end
  end

  # POST /events/1/leave
  def leave
    Participant.destroy_by(user_id: @current_user.id, event_id: @event.id)
  end

  # GET /events/1/participants
  def participants
    participants = Participant.where(event_id: @event.id)

    render json: participants.map(&:user)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    id = params[:id] || params[:event_id]

    @event = Event.find(id)
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
