module AdminArea
  class VolunteerAssignmentsController < ApplicationController
    before_action :require_admin_login
    before_action :set_assignment, only: [:approve, :reject, :mark_completed, :log_hours, :destroy]

    def index
      @pending   = VolunteerAssignment.includes(:volunteer, :event).pending.order(created_at: :desc)
      @approved  = VolunteerAssignment.includes(:volunteer, :event).approved.order(created_at: :desc)
      @completed = VolunteerAssignment.includes(:volunteer, :event).completed.order(created_at: :desc)
      @cancelled = VolunteerAssignment.includes(:volunteer, :event).cancelled.order(created_at: :desc)
    end

    # PATCH /admin_area/volunteer_assignments/:id/approve
    def approve
      event = @assignment.event

      if event.completed?
        redirect_back fallback_location: admin_area_volunteer_assignments_path,
                      alert: "Cannot approve sign-ups for a completed event."
        return
      end

      # prevent overfilling
      if event.approved_volunteer_count >= event.required_number_of_volunteers.to_i
        redirect_back fallback_location: admin_area_volunteer_assignments_path,
                      alert: "Event is already full. Increase required volunteers or reject/cancel someone first."
        return
      end

      if @assignment.update(status: :approved)
        redirect_to admin_area_volunteer_assignments_path, notice: "Sign-up approved."
      else
        redirect_to admin_area_volunteer_assignments_path, alert: @assignment.errors.full_messages.to_sentence
      end
    end

    # PATCH /admin_area/volunteer_assignments/:id/reject
    def reject
      if @assignment.update(status: :cancelled)
        redirect_to admin_area_volunteer_assignments_path, notice: "Sign-up rejected."
      else
        redirect_to admin_area_volunteer_assignments_path, alert: @assignment.errors.full_messages.to_sentence
      end
    end

    # PATCH /admin_area/volunteer_assignments/:id/mark_completed
    def mark_completed
      unless @assignment.event.completed?
        redirect_to admin_area_volunteer_assignments_path,
                    alert: "Event must be marked completed before completing assignments."
        return
      end

      if @assignment.update(status: :completed)
        redirect_to admin_area_volunteer_assignments_path, notice: "Assignment marked completed."
      else
        redirect_to admin_area_volunteer_assignments_path, alert: @assignment.errors.full_messages.to_sentence
      end
    end

    # PATCH /admin_area/volunteer_assignments/:id/log_hours
    def log_hours
      # Your model requires COMPLETED before hours/date can be set.
      unless @assignment.completed?
        redirect_to admin_area_volunteer_assignments_path,
                    alert: "Mark the assignment completed first, then log hours."
        return
      end

      if @assignment.update(log_hours_params)
        redirect_to admin_area_volunteer_assignments_path, notice: "Hours logged."
      else
        redirect_to admin_area_volunteer_assignments_path, alert: @assignment.errors.full_messages.to_sentence
      end
    end

    # DELETE /admin_area/volunteer_assignments/:id
    def destroy
      @assignment.destroy
      redirect_to admin_area_volunteer_assignments_path, notice: "Assignment removed."
    end

    private

    def set_assignment
      @assignment = VolunteerAssignment.find(params[:id])
    end

    def log_hours_params
      params.require(:volunteer_assignment).permit(:hours_worked, :date_logged)
    end
  end
end