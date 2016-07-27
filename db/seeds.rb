# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
1000000000.times do
  Post.create!(
    title: Time.now.to_s + rand(9999999999).to_s + rand(9999999999).to_s + rand(999999999).to_s,
    body: 'asdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdqwewqeqweqweqweqwewqeasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdasdqwewqeqweqweqweqwewqe',
    tags: 'asdasdq132123213213123'
  )
end