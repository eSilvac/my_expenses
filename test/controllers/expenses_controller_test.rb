require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "index when not signed in" do
    get expenses_path
    assert_redirected_to new_user_session_path
  end

  test "index when signed in" do
    get expenses_path
    assert :success
    post user_session_path 'user[email]' => users(:one).email, 'user[password]' => "pass1234"
    assert_redirected_to expenses_path
  end
end
