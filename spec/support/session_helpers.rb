module SessionHelpers
  def login_as_volunteer(volunteer)
    post login_path, params: {
      session: {
        username: volunteer.username,
        password: volunteer.password || "password123"
      }
    }
  end

  def login_as_admin(admin)
    post login_path, params: {
      session: {
        username: admin.username,
        password: admin.password || "password123"
      }
    }
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :request
end
