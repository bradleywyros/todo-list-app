# db/seeds.rb
require 'faker'

Item.delete_all
List.delete_all
User.delete_all

user_password = 'bradroz'
puts "User Password length: #{user_password.length}"
user = User.create!(name: 'bradroz', email: 'bradleywyros@gmail.com', password: user_password)
other_password = 'testUser2'
puts "Other Password length: #{other_password.length}"
other_user = User.create!(name: 'testUser2', email: 'bradleywyros@yahoo.com', password: other_password)
admin_password = 'BrAdmin123'
puts "Admin Password length: #{admin_password.length}"
admin = User.create!(name: 'BrAdmin', email: 'bradmin@gmail.com', password: admin_password, admin: true)

list = List.create(
  name: "My Todo List",
  user_id: user.id
)

10.times do
  Item.create(
    title: Faker::Lorem.word,
    description: Faker::Lorem.sentence(word_count: 3),
    duedate: Faker::Time.forward(days: rand(1..31), period: :morning),
    list_id: list.id
  )
end

list_2 = List.create(
  name: 'Test User 2 List',
  user_id: other_user.id
)

10.times do
  Item.create(
    title: Faker::Lorem.word,
    description: Faker::Lorem.sentence(word_count: 3),
    duedate: Faker::Time.forward(days: rand(1..31), period: :morning),
    list_id: list_2.id
  )
end