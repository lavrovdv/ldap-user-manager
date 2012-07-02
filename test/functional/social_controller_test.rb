require 'test_helper'

class SocialControllerTest < ActionController::TestCase
  test "should get vk" do
    get :vk
    assert_response :success
  end

  test "should get od" do
    get :od
    assert_response :success
  end

  test "should get fb" do
    get :fb
    assert_response :success
  end

end
