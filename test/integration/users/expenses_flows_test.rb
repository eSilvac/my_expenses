require 'application_system_test_case'

class ExpensesFlowsTest < ApplicationSystemTestCase
  test "user can create expense", js: true do
    visit expenses_path
    user_login
    expense_create
    assert page.has_selector?('.alert-success')

    expense = Expense.find_by_concept('Test1')
    assert_not expense.nil?
    assert_equal expense.concept, 'Test1'
    assert_equal expense.transaction_type, 'purchase'
    assert_equal expense.amount, 10000
    assert_equal expense.category.name, 'CategoryTest'
  end

  test "user can destroy expense", js: true do
    visit expenses_path
    user_login
    expense_create
    find('#expenses-table .delete', visible: false).hover.click
    page.driver.browser.switch_to.alert.accept
    assert page.has_selector?('.alert-danger')

    sleep 1
    expense = Expense.find_by_concept('Test1')
    assert expense.nil?
  end

  private
    def user_login
      fill_in 'Email', with: users(:one).email
      fill_in 'Password', with: 'pass1234'
      click_button 'Log in'
    end

    def expense_create
      click_link "New Expense"
      fill_in 'Concept', with: 'Test1'
      fill_in 'Amount', with: '10000'
      select 'Purchase', from: 'expense_transaction_type'
      find('.creat-category').click
      fill_in 'New Category Name', with: 'CategoryTest'
      click_button 'Create Expense'
    end
end