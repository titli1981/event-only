class EventsController < ApplicationController
  before_action do
    @location = Location.find(params[:location_id])
  end

  def index
    @events = @location.events
  end

  def show
    @event = Event.find(params[:id])
    ensure_location_match
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to [@location, @event]
    else
      redirect_back_or_to [@location, @event]
    end
  end

  def new
    
    @location = Location.find(params[:location_id])
    @event = Event.new

    @params = params
  end

  def create
    @event = Event.new(event_params)
    @event.location = @location

    if @event.save
      redirect_to [@location, @event]
    else
      redirect_to new_location_event_path
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to location_events_path
  end

  def ensure_location_match
    if @event.location != @location
      not_found
    end
  end

  def event_params
    params.require(:event).permit(:name, :date)
  end
end
