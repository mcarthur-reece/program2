class AdminArea::VolunteerAssignmentsController < ApplicationController
  before_action :require_admin_login
  before_action :set_assignment, only: [ :show, :edit, :update, :destroy, :approve, :reject ]

  # GET /admin_area/volunteer_assignments
  def index
    @assignments = VolunteerAssignment.includes(:volunteer, :event).all

    # Optional: Filter by status
    if params[:status].present?
      @assignments = @assignments.where(status: params[:status])
    end

    # Optional: Filter by event
    if params[:event_id].present?
      @assignments = @assignments.where(event_id: params[:event_id])
    end

    @assignments = @assignments.order(created_at: :desc)
  end

  # GET /admin_area/volunteer_assignments/:id
  def show
  end

  # GET /admin_area/volunteer_assignments/new
  def new
    @assignment = VolunteerAssignment.new
    @volunteers = Volunteer.all.order(:full_name)
    @events = Event.where(status: [ "open", "full" ]).order(:event_date)
  end

  # POST /admin_area/volunteer_assignments
  def create
    @assignment = VolunteerAssignment.new(assignment_params)
    @assignment.status = "approved"  # Admin-created assignments are auto-approved

    if @assignment.save
      flash[:success] = "Volunteer successfully assigned to event."
      redirect_to admin_area_volunteer_assignments_path
    else
      @volunteers = Volunteer.all.order(:full_name)
      @events = Event.where(status: [ "open", "full" ]).order(:event_date)
      flash.now[:alert] = "Failed to create assignment."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /admin_area/volunteer_assignments/:id/edit
  def edit
    @volunteers = Volunteer.all.order(:full_name)
    @events = Event.all.order(:event_date)
  end

  # PATCH/PUT /admin_area/volunteer_assignments/:id
  def update
    if @assignment.update(assignment_params)
      flash[:success] = "Assignment updated successfully."
      redirect_to admin_area_volunteer_assignments_path
    else
      @volunteers = Volunteer.all.order(:full_name)
      @events = Event.all.order(:event_date)
      flash.now[:alert] = "Failed to update assignment."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin_area/volunteer_assignments/:id
  def destroy
    volunteer_name = @assignment.volunteer.full_name
    event_title = @assignment.event.title

    @assignment.destroy

    flash[:success] = "Removed #{volunteer_name} from #{event_title}."
    redirect_to admin_area_volunteer_assignments_path
  end

  # PATCH /admin_area/volunteer_assignments/:id/approve
  def approve
    if @assignment.update(status: "approved")
      flash[:success] = "Assignment approved successfully."
    else
      flash[:alert] = "Failed to approve assignment."
    end
    redirect_to admin_area_volunteer_assignments_path
  end

  # PATCH /admin_area/volunteer_assignments/:id/reject
  def reject
    if @assignment.update(status: "cancelled")
      flash[:success] = "Assignment rejected successfully."
    else
      flash[:alert] = "Failed to reject assignment."
    end
    redirect_to admin_area_volunteer_assignments_path
  end

  private

  def set_assignment
    @assignment = VolunteerAssignment.find(params[:id])
  end

  def assignment_params
    params.require(:volunteer_assignment).permit(
      :volunteer_id,
      :event_id,
      :status,
      :hours_worked,
      :date_logged
    )
  end
end
