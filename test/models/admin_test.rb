require "test_helper"

class AdminTest < ActiveSupport::TestCase
  # Test fixtures setup
  def setup
    @admin = Admin.new(
      username: "admin_user",
      password: "password123",
      password_confirmation: "password123",
      name: "Admin User",
      email: "admin@example.com"
    )
  end

  # === Validation Tests ===

  test "should be valid with valid attributes" do
    assert @admin.valid?
  end

  test "username should be present" do
    @admin.username = "   "
    assert_not @admin.valid?
    assert_includes @admin.errors[:username], "can't be blank"
  end

  test "username should be unique" do
    duplicate_admin = @admin.dup
    @admin.save
    assert_not duplicate_admin.valid?
    assert_includes duplicate_admin.errors[:username], "has already been taken"
  end

  test "name should be present" do
    @admin.name = "   "
    assert_not @admin.valid?
    assert_includes @admin.errors[:name], "can't be blank"
  end

  test "email should be present" do
    @admin.email = "   "
    assert_not @admin.valid?
    assert_includes @admin.errors[:email], "can't be blank"
  end

  test "email should be unique" do
    duplicate_admin = @admin.dup
    duplicate_admin.username = "different_admin"
    @admin.save
    assert_not duplicate_admin.valid?
    assert_includes duplicate_admin.errors[:email], "has already been taken"
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[admin@example.com ADMIN@foo.COM A_ADMIN@foo.bar.org
                         admin.user@foo.jp alice+admin@baz.cn]
    valid_addresses.each do |valid_address|
      @admin.email = valid_address
      assert @admin.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[admin@example,com admin_at_foo.org admin.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @admin.email = invalid_address
      assert_not @admin.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

test "password should be present (nonblank)" do
  @admin.password = @admin.password_confirmation = "      "
  assert_not @admin.valid?, "Password with only spaces should be invalid"
  assert_includes @admin.errors[:password], "can't be blank"
end

  test "password should have a minimum length" do
    @admin.password = @admin.password_confirmation = "a" * 5
    assert_not @admin.valid?
    assert_includes @admin.errors[:password], "is too short (minimum is 6 characters)"
  end

  # === Password Authentication Tests ===

  test "authenticated? should return true for correct password" do
    @admin.save
    assert @admin.authenticate("password123")
  end

  test "authenticated? should return false for incorrect password" do
    @admin.save
    assert_not @admin.authenticate("wrongpassword")
  end

  # === Database Constraint Tests ===

  test "username should be saved in database" do
    @admin.save
    saved_admin = Admin.find_by(username: "admin_user")
    assert_not_nil saved_admin
    assert_equal @admin.username, saved_admin.username
  end

test "email should be case-insensitive unique" do
    @admin.email = "Admin@Example.COM"
    @admin.save
    
    duplicate = Admin.new(
      username: "different_admin",
      password: "password123",
      password_confirmation: "password123",
      name: "Another Admin",
      email: "admin@example.com"  # lowercase version of same email
    )
    
    assert_not duplicate.valid?, "Duplicate email with different case should be invalid"
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  # === Password Update Tests ===

  test "should allow password updates" do
    @admin.save
    @admin.password = @admin.password_confirmation = "newpassword123"
    assert @admin.save
    assert @admin.authenticate("newpassword123")
  end

  test "should not require password on update if not changing it" do
    @admin.save
    @admin.name = "New Admin Name"
    assert @admin.valid?
    assert @admin.save
  end

  # === Admin-Specific Business Logic Tests ===

  test "admin should not have total_hours attribute (unlike volunteers)" do
    assert_not @admin.respond_to?(:total_hours), "Admin should not have total_hours attribute"
  end

  test "multiple admins can be created" do
    @admin.save
    
    second_admin = Admin.new(
      username: "admin2",
      password: "password123",
      password_confirmation: "password123",
      name: "Second Admin",
      email: "admin2@example.com"
    )
    
    assert second_admin.valid?
    assert second_admin.save
    assert_equal 2, Admin.count
  end
end