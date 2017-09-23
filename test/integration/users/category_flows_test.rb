require 'application_system_test_case'

class CategoryFlowsTest < ApplicationSystemTestCase
  test "user can create category", js: true do
    visit expenses_path
    user_login
    click_link "New Category"
    fill_in "category[name]", with: "Category2Test"
    find("#category_button").click
    
    assert page.has_selector?('.alert-success')
    assert page.has_content?("Category2Test")
  end

  test "user can destroy category", js: true do
    visit expenses_path
    user_login

    find(".category-list .category-destroy span", visible: false).hover.click
    page.driver.browser.switch_to.alert.accept
    
    sleep 1
    assert page.has_selector?('.alert-danger')
    category = Category.find_by(name: "Games")
    assert_nil category
  end

  private
    def user_login
      fill_in 'Email', with: users(:one).email
      fill_in 'Password', with: 'pass1234'
      click_button 'Log in'
    end
end 