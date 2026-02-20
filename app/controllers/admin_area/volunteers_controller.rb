module AdminArea
  class VolunteersController < ApplicationController
    before_action :require_admin_login
    before_action :set_volunteer, only: [:show, :edit, :update, :destroy]

    def index
      @volunteers = Volunteer.order(:id)
    end

    def show
    end

    def new
      @volunteer = Volunteer.new
    end

    def create
      @volunteer = Volunteer.new(volunteer_params)
      if @volunteer.save
        redirect_to admin_area_volunteers_path, notice: "Volunteer created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @volunteer.update(volunteer_params_update)
        redirect_to admin_area_volunteers_path(@volunteer), notice: "Volunteer updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @volunteer.destroy
      redirect_to admin_area_volunteers_path, notice: "Volunteer deleted."
    end

    private

    def set_volunteer
      @volunteer = Volunteer.find(params[:id])
    end

    # For create: allow setting password
    def volunteer_params
      params.require(:volunteer).permit(
        :username, :password, :password_confirmation,
        :full_name, :email, :phone_number, :address, :skills_interests
      )
    end

    # For update: password optional (don’t force changing it)
    def volunteer_params_update
      permitted = params.require(:volunteer).permit(
        :full_name, :email, :phone_number, :address, :skills_interests,
        :password, :password_confirmation
      )

      # If password left blank, don’t update it
      if permitted[:password].blank? && permitted[:password_confirmation].blank?
        permitted.except(:password, :password_confirmation)
      else
        permitted
      end
    end
  end
end
