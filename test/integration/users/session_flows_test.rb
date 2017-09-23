require 'application_system_test_case'

class SessionFlowsTest < ApplicationSystemTestCase
  test "users can login" do
    visit root_path
    click_link "Login"
    fill_in 'Email', with: users(:one).email
    fill_in 'Password', with: 'pass1234'
    click_button 'Log in'
    assert page.has_content?("Dashboard")
    assert page.has_content?("#{users(:one).name}")
    assert_not page.has_content?("Log in")
  end

  test "users can logout", js: true do
    visit root_path
    click_link "Login"
    fill_in 'Email', with: users(:one).email
    fill_in 'Password', with: 'pass1234'
    click_button 'Log in'
    
    click_link "#{users(:one).name}"
    click_link "Log Out"   
    
    assert_not page.has_content?("New Expense")
    assert page.has_content?("Login")
    assert page.has_content?("Sign Up")
  end

  test "user can see his apikey", js: true do
    visit root_path
    click_link "Login"
    fill_in 'Email', with: users(:one).email
    fill_in 'Password', with: 'pass1234'
    click_button 'Log in'

    click_link "#{users(:one).name}"
    click_link "ApiKey"

    assert page.has_content?(User.find_by(email: users(:one).email).api_token)
  end
end