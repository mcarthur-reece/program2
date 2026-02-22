# Volunteer Management System

A Ruby on Rails web application for managing volunteers, events, and volunteer assignments.

## Live Deployment
This application is deployed and accessbile at http://152.7.178.162:8080 

## 🔐 Admin Credentials 
Pre-configured admin account:
- Username: admin
- Password: password123
- Email: admin@volunteer.org

## 📌 Feature Instructions
Below are instructions for acessing key features in the application 

### ✅ Volunteer Features
✅ Sign Up for an Event

1. Log in as a volunteer.

2. From the volunteer dashboard, click “Browse Available Events.”

3. On the Available Events page, click the “View” button next to the desired event.

4. Click the "Sign Up For This Event" butotn

Your status is pending until an admin approves you. 


❌ Withdraw from an Event

1. Log in as a volunteer.

2. From the volunteer dashboard, click “My Events.”

3. On the My Events page, locate the event you want to withdraw from.

4. Click the “Withdraw” button next to that event.

The volunteer will be removed from the event.

### 🛠️ Admin Features 
➕ Create a New Event

1. Log in using the admin credentials.

2. Click “Manage Events.”

3. Click the “Create New Event” button.

4. Fill out the event form.

5. Click “Create Event.”

The new event will now appear in the events listing. 

⏱️ Log Volunteer Hours

1. Log in as an admin.

2. Admin Dashboard → Manage Assignments / Approvals.

3. Locate the desired volunteer assignment.

4. Click the “Edit” button.

5. ONLY once event has been marked completed, you may fill out the Volunteer Hours section. Enter number of hours.  

6. Click "Update Assignment" 

Volunteer assignment hours are now logged. 

## 🧪 Testing Guide 
To test the application workflow:

## Volunteer Testing

- Create a volunteer account via Sign Up.

- Log in and sign up for an event.

- Verify the event appears under My Events.

- Withdraw and confirm it no longer appears.

## Admin Testing

- Log in with the admin credentials.

- Create a new event. Verify it appears under Manage Events. 

- Approve volunteer assignments. 

- Mark assignments as completed.

- Log volunteer hours.

## Prerequisites

- Ruby 3.3.x or higher
- Rails 8.x
- postgresql

## Setup Instructions (Local Development)

### 1. Clone the Repository
```bash
git clone https://github.com/cjbhatna_ncstate/CSC_ECE_517_Spring_2026_Program_2.git
cd CSC_ECE_517_Spring_2026_Program_2
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Set Up the Database
```bash
# Ensure postgresql is running
#on macOs:
brew services start postgresql
#on Linux:
sudo service postgresql start
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