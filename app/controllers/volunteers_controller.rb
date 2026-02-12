class VolunteersController < ApplicationController
  before_action :require_volunteer_login, only: [ :show, :edit, :update, :destroy ]
  before_action :require_correct_volunteer, only: [ :show, :edit, :update, :destroy ]

  # GET /signup
  def new
    @volunteer = Volunteer.new
  end

  # POST /signup
  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      session[:volunteer_id] = @volunteer.id
      flash[:success] = "Welcome, #{@volunteer.full_name}! Your account has been created."
      redirect_to volunteer_path(@volunteer)
    else
      flash.now[:alert] = "There was an error creating your account."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /volunteers/:id
  def show
    @volunteer = Volunteer.find(params[:id])
  end

  # GET /volunteers/:id/edit
  def edit
    @volunteer = Volunteer.find(params[:id])
  end

  # PATCH/PUT /volunteers/:id
  def update
    @volunteer = Volunteer.find(params[:id])

    if @volunteer.update(volunteer_update_params)
      flash[:success] = "Your profile has been updated successfully."
      redirect_to volunteer_path(@volunteer)
    else
      flash.now[:alert] = "There was an error updating your profile."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /volunteers/:id
  def destroy
    @volunteer = Volunteer.find(params[:id])
    @volunteer.destroy

    session[:volunteer_id] = nil
    flash[:success] = "Your account has been deleted successfully."
    redirect_to root_path
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(
      :username,
      :password,
      :password_confirmation,
      :full_name,
      :email,
      :phone_number,
      :address,
      :skills_interests
    )
  end

  def volunteer_update_params
    # Username cannot be changed
    params.require(:volunteer).permit(
      :password,
      :password_confirmation,
      :full_name,
      :email,
      :phone_number,
      :address,
      :skills_interests
    )
  end
end
