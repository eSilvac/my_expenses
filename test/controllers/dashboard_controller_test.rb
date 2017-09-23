require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "dashboard when not signed in" do
    get dashboard_index_path
    assert_redirected_to new_user_session_path
  end

  test "dashboard when signed in" do
    get dashboard_index_path
    assert :success
    post user_session_path 'user[email]' => users(:one).email, 'user[password]' => "pass1234"
    assert_redirected_to dashboard_index_path
  end
end
