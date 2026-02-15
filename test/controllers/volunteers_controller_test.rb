require "test_helper"

class VolunteersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get volunteers_new_url
    assert_response :success
  end

  test "should get create" do
    get volunteers_create_url
    assert_response :success
  end

  test "should get show" do
    get volunteers_show_url
    assert_response :success
  end

  test "should get edit" do
    get volunteers_edit_url
    assert_response :success
  end

  test "should get update" do
    get volunteers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get volunteers_destroy_url
    assert_response :success
  end
end
