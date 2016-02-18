# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(first_name: 'Matt', last_name: 'Dick', email: 'matt@gmail.com', password: 'password', password_confirmation: 'password')
User.create(first_name: 'Tony', last_name: 'DeCino', email: 'tony@gmail.com', password: 'password', password_confirmation: 'password')
(1..10).each do |user_num|
  User.create(first_name: 'User', last_name: user_num, email: "user#{user_num}@gmail.com", password: 'password', password_confirmation: 'password')
end