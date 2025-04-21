# db/seeds.rb
require 'faker'

Item.delete_all
List.delete_all
User.delete_all

user1 = User.create!(name: 'User1', email: 'no-reply@email.com', password: 'User1Pw')
user2 = User.create!(name: 'User2', email: 'no-reply2@email.com', password: 'User2Pw')
admin = User.create!(name: 'Admin', email: 'no-reply-admin@email.com', password: 'AdminPw123', admin: true)

list = List.create(
  name: "My Todo List",
  user_id: user1.id
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
  user_id: user2.id
)

10.times do
  Item.create(
    title: Faker::Lorem.word,
    description: Faker::Lorem.sentence(word_count: 3),
    duedate: Faker::Time.forward(days: rand(1..31), period: :morning),
    list_id: list_2.id
  )
end