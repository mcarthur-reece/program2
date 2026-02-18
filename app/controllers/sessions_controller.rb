class SessionsController < ApplicationController
  # GET /login
  def new
    # Redirect if already logged in
    if current_user
      redirect_to volunteer_path(current_user)
    elsif current_admin
      redirect_to root_path  # Changed from admin_path since it doesn't exist yet
    end
  end

  # POST /login
  def create
    username = params[:session][:username]
    password = params[:session][:password]

    # Try to authenticate as volunteer
    volunteer = Volunteer.find_by(username: username)
    if volunteer && volunteer.authenticate(password)
      session[:volunteer_id] = volunteer.id
      flash[:success] = "Welcome back, #{volunteer.full_name}!"
      redirect_to volunteer_path(volunteer)
      return
    end

    # Try to authenticate as admin
    admin = Admin.find_by(username: username)
    if admin && admin.authenticate(password)
      session[:admin_id] = admin.id
      flash[:success] = "Welcome back, #{admin.name}!"
      redirect_to root_path # Person 3 will change this to admin dashboard
      return
    end

    # Authentication failed
    flash.now[:alert] = "Invalid username or password"
    render :new, status: :unprocessable_entity
  end

  # DELETE /logout
  def destroy
    user_name = current_user&.full_name || current_admin&.name || "User"

    session[:volunteer_id] = nil
    session[:admin_id] = nil

    flash[:success] = "Goodbye, #{user_name}! You have been logged out."
    redirect_to login_path
  end
end
