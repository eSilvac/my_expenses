# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Clear DB
User.destroy_all
Category.destroy_all
Expense.destroy_all

# Users

User1 = User.create!(email: 'example1@example.com', password: 'test1234', first_name: 'Esteban', last_name: 'Silva')
User2 = User.create!(email: 'example2@example.com', password: 'test1234', first_name: 'Gabriela', last_name: 'Yepes')

# Categories

5.times do
  Category.create!(name: Faker::Commerce.unique.department(1, true), users: [User1])
  Category.create!(name: Faker::Commerce.unique.department(1, true), users: [User2])
end

# Expenses

250.times do
  Expense.create!(
    concept: Faker::Commerce.product_name, 
    transaction_type: Faker::Number.between(0, 3), 
    amount: Faker::Number.between(100000, 10000000), 
    date: Faker::Date.between(6.months.ago, Date.today), 
    user: User1, 
    category: User1.categories.sample)

  Expense.create!(
    concept: Faker::Commerce.product_name, 
    transaction_type: Faker::Number.between(0, 3), 
    amount: Faker::Number.between(100000, 10000000), 
    date: Faker::Date.between(6.months.ago, Date.today), 
    user: User2, 
    category: User2.categories.sample)
end