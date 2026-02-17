class EventsController < ApplicationController
  before_action :require_login, only: %i[index show]
  before_action :require_admin_login, except: %i[index show]
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events
  def index
    @events = Event.order(event_date: :asc, start_time: :asc)
  end

  # GET /events/:id
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      flash[:success] = "Event created successfully."
      redirect_to event_path(@event)
    else
      flash.now[:alert] = "Could not create event."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /events/:id/edit
  def edit
  end

  # PATCH/PUT /events/:id
  def update
    if @event.update(event_params)
      flash[:success] = "Event updated successfully."
      redirect_to event_path(@event)
    else
      flash.now[:alert] = "Could not update event."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id
  def destroy
    @event.destroy
    flash[:success] = "Event deleted."
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title,
      :description,
      :location,
      :event_date,
      :start_time,
      :end_time,
      :required_number_of_volunteers,
      :status
    )
  end
end
