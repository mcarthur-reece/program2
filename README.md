# Volunteer Management System

A Ruby on Rails web application for managing volunteers, events, and volunteer assignments.

## Prerequisites

- Ruby 3.3.x or higher
- Rails 8.x
- SQLite3 (comes with macOS and most Linux distributions)

## Setup Instructions

### 1. Clone the Repository
```bash
git clone git@github.ncsu.edu:your-unity-id/volunteer_management_system.git
cd volunteer_management_system
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Set Up the Database
```bash
# Create the database
rails db:create

# Run migrations to create tables
rails db:migrate

# Seed the database with initial admin account
rails db:seed
```

### 4. Start the Server
```bash
rails server
```

### 5. Access the Application
Navigate to `http://localhost:3000` in your web browser.

## Admin Credentials

**Pre-configured admin account:**
- **Username**: `admin`
- **Password**: `password123`
- **Email**: `admin@volunteer.org`

⚠️ **Important**: Change the admin password after first login in production!

## Database Schema

### Current Tables:
- **Volunteers**: User accounts for volunteers with profile information
- **Admins**: Administrator account (pre-seeded, cannot be deleted)

### Coming Soon:
- **Events**: Volunteering opportunities
- **Volunteer Assignments**: Track volunteer participation in events

## Testing

To run the test suite:
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/volunteer_test.rb
```

## Development Notes

- SQLite is used for development and testing
- For production deployment, consider switching to PostgreSQL
- All passwords are encrypted using BCrypt

## Team Members

- Person 1: Authentication & Volunteer Management
- Person 2: Events & Assignments
- Person 3: Admin Features & UI

## License

This project is created for CSC/ECE 517 at NC State University.