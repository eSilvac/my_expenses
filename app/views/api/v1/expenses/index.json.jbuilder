json.array! @expenses do |expenses|
  json.id expenses.id
  json.type expenses.transaction_type
  json.concept expenses.concept
  json.date expenses.date
  json.category_id expenses.category_id
  json.price expenses.amount
  json.created_at expenses.created_at
  json.updated_at expenses.updated_at
end