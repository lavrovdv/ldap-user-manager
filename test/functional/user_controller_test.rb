require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get find" do
    get :find
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

end
