class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Disable CSRF protection in test environment
  protect_from_forgery with: :exception unless Rails.env.test?

  helper_method :current_user, :current_admin, :logged_in?, :admin_logged_in?

  private

  # Get current logged-in volunteer
  def current_user
    @current_user ||= Volunteer.find_by(id: session[:volunteer_id]) if session[:volunteer_id]
  end

  # Get current logged-in admin
  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end

  # Check if any user is logged in (volunteer or admin)
  def logged_in?
    current_user.present? || current_admin.present?
  end

  # Check if admin is logged in
  def admin_logged_in?
    current_admin.present?
  end

  # Require login (volunteer or admin)
  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  # Require volunteer login only
  def require_volunteer_login
    unless current_user
      flash[:alert] = "You must be logged in as a volunteer to access this page."
      redirect_to login_path
    end
  end

  # Require admin login only
  def require_admin_login
    unless current_admin
      flash[:alert] = "You must be logged in as an admin to access this page."
      redirect_to login_path
    end
  end

  # Ensure volunteers can only access their own resources
  def require_correct_volunteer
    @volunteer = Volunteer.find_by(id: params[:id])
    unless @volunteer && current_user == @volunteer
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end
end
