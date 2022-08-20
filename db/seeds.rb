# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!( name: "admin",
              email: "admin@example.com", 
              password: "password",
              password_confirmation: "password",
              admin: true)

10.times do |i|
  User.create!( name: "user#{i + 1}",
                email: "user#{i + 1}@example.com", 
                password: "password#{i + 1}",
                password_confirmation: "password#{i + 1}",
                admin: false)
end

10.times do |i|
  Label.create!(name: "sample#{i + 1}")
end

10.times do |i|
  Task.create!( title: "task#{i + 1}",
                content: "task#{i + 1}",
                deadline: "now()",
                status: '未着手',
                priority: '低',
                user_id: 1
                )
end