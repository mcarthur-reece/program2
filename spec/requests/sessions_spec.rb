require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    context "when not logged in" do
      it "displays the login form" do
        get login_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Login")
      end
    end

    context "when volunteer is already logged in" do
      let(:volunteer) { create(:volunteer, password: "password123", password_confirmation: "password123") }

      before do
        login_as_volunteer(volunteer)
      end

      it "redirects to volunteer profile" do
        get login_path
        expect(response).to redirect_to(volunteer_path(volunteer))
      end
    end

    context "when admin is already logged in" do
      let(:admin) { create(:admin, password: "password123", password_confirmation: "password123") }

      before do
        login_as_admin(admin)
      end

      it "redirects to root path" do
        get login_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /login" do
    context "with valid volunteer credentials" do
    let(:volunteer) { create(:volunteer, username: "john_doe", password: "password123", password_confirmation: "password123") }

    it "logs in the volunteer" do
      # DEBUG: Check volunteer object
      puts "\n=== VOLUNTEER DEBUG ==="
      puts "Username: #{volunteer.username}"
      puts "Persisted?: #{volunteer.persisted?}"
      puts "ID: #{volunteer.id}"
      puts "Password digest present?: #{volunteer.password_digest.present?}"
      puts "Can authenticate?: #{volunteer.authenticate('password123').present?}"
      puts "=======================\n"

      post login_path, params: {
        session: {
          username: volunteer.username,  # Use actual username
          password: "password123"
        }
      }

      # DEBUG: Check response
      puts "\n=== RESPONSE DEBUG ==="
      puts "Status: #{response.status}"
      puts "Flash alert: #{flash[:alert]}"
      puts "Flash success: #{flash[:success]}"
      puts "Session volunteer_id: #{session[:volunteer_id]}"
      if response.status == 422
        puts "Response body (first 1000 chars):"
        puts response.body[0..1000]
      end
      puts "=======================\n"

      expect(response).to redirect_to(volunteer_path(volunteer))
    end
  end

  context "with valid admin credentials" do
    let(:admin) { create(:admin, username: "admin_user", password: "password123", password_confirmation: "password123") }

    it "logs in the admin" do
      admin.reload

      post login_path, params: {
        session: {
          username: admin.username,
          password: "password123"
        }
      }

      expect(response).to redirect_to(root_path)
      # Don't check body content since root_path doesn't have content yet
      # Person 3 will create the admin dashboard
    end

    it "sets the admin session" do
      post login_path, params: {
        session: {
          username: admin.username,
          password: "password123"
        }
      }

      expect(session[:admin_id]).to eq(admin.id)
      expect(session[:volunteer_id]).to be_nil
    end
  end

    context "with invalid credentials" do
      let(:volunteer) { create(:volunteer, username: "john_doe", password: "password123", password_confirmation: "password123") }

      it "does not log in with wrong password" do
        post login_path, params: {
          session: {
            username: "john_doe",
            password: "wrongpassword"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid username or password")
        expect(session[:volunteer_id]).to be_nil
        expect(session[:admin_id]).to be_nil
      end

      it "does not log in with non-existent username" do
        post login_path, params: {
          session: {
            username: "nonexistent",
            password: "password123"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Invalid username or password")
      end
    end

    context "with missing credentials" do
      it "handles missing username" do
        post login_path, params: {
          session: {
            username: "",
            password: "password123"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "handles missing password" do
        volunteer = create(:volunteer, username: "john_doe")

        post login_path, params: {
          session: {
            username: "john_doe",
            password: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /logout" do
    context "when volunteer is logged in" do
      let(:volunteer) { create(:volunteer, password: "password123", password_confirmation: "password123") }

      before do
        login_as_volunteer(volunteer)
      end

      it "logs out the volunteer" do
        delete logout_path

        expect(response).to redirect_to(login_path)
        expect(session[:volunteer_id]).to be_nil
      end

      it "displays logout success message" do
        delete logout_path
        follow_redirect!

        expect(response.body).to include("logged out")
      end
    end

    context "when admin is logged in" do
      let(:admin) { create(:admin, password: "password123", password_confirmation: "password123") }

      before do
        login_as_admin(admin)
      end

      it "logs out the admin" do
        delete logout_path

        expect(response).to redirect_to(login_path)
        expect(session[:admin_id]).to be_nil
      end
    end

    context "when not logged in" do
      it "still redirects to login page" do
        delete logout_path

        expect(response).to redirect_to(login_path)
      end
    end
  end
end
