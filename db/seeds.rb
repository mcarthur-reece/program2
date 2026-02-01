# Clear existing data (be careful in production!)
Admin.destroy_all
puts "Cleared existing admins"

# Create admin account
admin = Admin.create!(
  username: 'admin',
  password: 'password123',
  password_confirmation: 'password123',
  name: 'System Administrator',
  email: 'admin@volunteer.org'
)

puts "Admin created successfully!"
puts "Username: #{admin.username}"
puts "Password: password123"
puts "Email: #{admin.email}"