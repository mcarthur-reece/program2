class VolunteerAssignmentsController < ApplicationController
  before_action :require_volunteer_login

  # GET /volunteer_assignments
  def index
    @assignments = current_user.volunteer_assignments
                               .includes(:event)
                               .order("events.event_date DESC, events.start_time DESC")
  end

  # DELETE /volunteer_assignments/:id
  def destroy
    assignment = current_user.volunteer_assignments.find(params[:id])

    # Either approach is acceptable; hard-delete is simplest and releases the slot immediately.
    assignment.destroy

    flash[:success] = "You have withdrawn from the event."
    redirect_to volunteer_assignments_path, status: :see_other
  end
end
