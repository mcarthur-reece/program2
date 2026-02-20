class AdminsController < ApplicationController 
    before_action :require_admin_login #only admins can access

    def dashboard
        @volunteer_count = Volunteer.count
        @event_count = Event.count
        
        @pending_assignments = VolunteerAssignment.where(status: "pending").count
        @approved_assignments = VolunteerAssignment.where(status: "approved").count
    end

    def edit_profile
        @admin = current_admin
    end

    def update_profile
        @admin = current_admin
        if @admin.update(admin_profile_params)
            flash[:success] = "Profile updated successfully."
            redirect_to admin_path
        else
            flash.now[:alert] = "Could not update profile."
            render :edit_profile, status: :unprocessable_entity
        end
    end

    private

    def admin_profile_params
        params.require(:admin).permit(:name, :email) #can only change these 
    end


end 