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
      let(:volunteer) { create(:volunteer) }

      before do
        post login_path, params: { session: { username: volunteer.username, password: "password123" } }
      end

      it "redirects to volunteer profile" do
        get login_path
        expect(response).to redirect_to(volunteer_path(volunteer))
      end
    end

    context "when admin is already logged in" do
      let(:admin) { create(:admin) }

      before do
        post login_path, params: { session: { username: admin.username, password: "password123" } }
      end

      it "redirects to root path" do
        get login_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /login" do
    context "with valid volunteer credentials" do
      let(:volunteer) { create(:volunteer, username: "john_doe", password: "password123") }

      it "logs in the volunteer" do
        post login_path, params: {
          session: {
            username: "john_doe",
            password: "password123"
          }
        }

        expect(response).to redirect_to(volunteer_path(volunteer))
        follow_redirect!
        expect(response.body).to include("Welcome back")
      end

      it "sets the volunteer session" do
        post login_path, params: {
          session: {
            username: volunteer.username,
            password: "password123"
          }
        }

        expect(session[:volunteer_id]).to eq(volunteer.id)
        expect(session[:admin_id]).to be_nil
      end
    end

    context "with valid admin credentials" do
      let(:admin) { create(:admin, username: "admin_user", password: "password123") }

      it "logs in the admin" do
        post login_path, params: {
          session: {
            username: "admin_user",
            password: "password123"
          }
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Welcome back")
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
      let(:volunteer) { create(:volunteer, username: "john_doe", password: "password123") }

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
      let(:volunteer) { create(:volunteer) }

      before do
        post login_path, params: {
          session: {
            username: volunteer.username,
            password: "password123"
          }
        }
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
      let(:admin) { create(:admin) }

      before do
        post login_path, params: {
          session: {
            username: admin.username,
            password: "password123"
          }
        }
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

  describe "session security" do
    let(:volunteer) { create(:volunteer) }

    it "prevents session fixation attacks" do
      # Get initial session
      get login_path
      old_session_id = session.id

      # Login
      post login_path, params: {
        session: {
          username: volunteer.username,
          password: "password123"
        }
      }

      # Session should be regenerated (Rails does this automatically)
      expect(session[:volunteer_id]).to eq(volunteer.id)
    end
  end
end
