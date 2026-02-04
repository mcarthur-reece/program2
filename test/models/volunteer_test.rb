require "test_helper"

class VolunteerTest < ActiveSupport::TestCase
  # Test fixtures setup
  def setup
    @volunteer = Volunteer.new(
      username: "john_doe",
      password: "password123",
      password_confirmation: "password123",
      full_name: "John Doe",
      email: "john@example.com",
      phone_number: "123-456-7890",
      address: "123 Main St",
      skills_interests: "Community service, teaching"
    )
  end

  # === Validation Tests ===
  
  test "should be valid with valid attributes" do
    assert @volunteer.valid?
  end

  test "username should be present" do
    @volunteer.username = "   "
    assert_not @volunteer.valid?
    assert_includes @volunteer.errors[:username], "can't be blank"
  end

  test "username should be unique" do
    duplicate_volunteer = @volunteer.dup
    @volunteer.save
    assert_not duplicate_volunteer.valid?
    assert_includes duplicate_volunteer.errors[:username], "has already been taken"
  end

  test "full_name should be present" do
    @volunteer.full_name = "   "
    assert_not @volunteer.valid?
    assert_includes @volunteer.errors[:full_name], "can't be blank"
  end

  test "email should be present" do
    @volunteer.email = "   "
    assert_not @volunteer.valid?
    assert_includes @volunteer.errors[:email], "can't be blank"
  end

  test "email should be unique" do
    duplicate_volunteer = @volunteer.dup
    duplicate_volunteer.username = "different_username"
    @volunteer.save
    assert_not duplicate_volunteer.valid?
    assert_includes duplicate_volunteer.errors[:email], "has already been taken"
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @volunteer.email = valid_address
      assert @volunteer.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @volunteer.email = invalid_address
      assert_not @volunteer.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

test "password should be present (nonblank)" do
  @volunteer.password = @volunteer.password_confirmation = "      "
  assert_not @volunteer.valid?, "Password with only spaces should be invalid"
  assert_includes @volunteer.errors[:password], "can't be blank"
end

  test "password should have a minimum length" do
    @volunteer.password = @volunteer.password_confirmation = "a" * 5
    assert_not @volunteer.valid?
    assert_includes @volunteer.errors[:password], "is too short (minimum is 6 characters)"
  end

  # === Password Authentication Tests ===

  test "authenticated? should return true for correct password" do
    @volunteer.save
    assert @volunteer.authenticate("password123")
  end

  test "authenticated? should return false for incorrect password" do
    @volunteer.save
    assert_not @volunteer.authenticate("wrongpassword")
  end

  # === Default Values Tests ===

  test "total_hours should default to 0.0" do
    @volunteer.save
    assert_equal 0.0, @volunteer.total_hours
  end

  # === Optional Fields Tests ===

  test "should be valid without phone_number" do
    @volunteer.phone_number = nil
    assert @volunteer.valid?
  end

  test "should be valid without address" do
    @volunteer.address = nil
    assert @volunteer.valid?
  end

  test "should be valid without skills_interests" do
    @volunteer.skills_interests = nil
    assert @volunteer.valid?
  end

  # === Database Constraint Tests ===

  test "username should be saved in database" do
    @volunteer.save
    saved_volunteer = Volunteer.find_by(username: "john_doe")
    assert_not_nil saved_volunteer
    assert_equal @volunteer.username, saved_volunteer.username
  end

test "email should be case-insensitive unique" do
    @volunteer.email = "Test@Example.COM"
    @volunteer.save
    
    duplicate = Volunteer.new(
      username: "different_user",
      password: "password123",
      password_confirmation: "password123",
      full_name: "Another User",
      email: "test@example.com"  # lowercase version of same email
    )
    
    assert_not duplicate.valid?, "Duplicate email with different case should be invalid"
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  # === Password Update Tests ===

  test "should allow password updates" do
    @volunteer.save
    @volunteer.password = @volunteer.password_confirmation = "newpassword123"
    assert @volunteer.save
    assert @volunteer.authenticate("newpassword123")
  end

  test "should not require password on update if not changing it" do
    @volunteer.save
    @volunteer.full_name = "Jane Doe"
    assert @volunteer.valid?
    assert @volunteer.save
  end
end