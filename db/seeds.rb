# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.find_or_create_by_name("Saeed") { |u| u.id = 1; u.picture = "assets/Saeed.jpg" }
User.find_or_create_by_name("Amir") { |u| u.id = 2; u.picture = "assets/Amir.jpg" }
User.find_or_create_by_name("Sadegh") { |u| u.id = 3; u.picture = "assets/Sadegh.jpg" }
User.find_or_create_by_name("Hamed") { |u| u.id = 4; u.picture = "assets/Hamed.jpg" }
User.find_or_create_by_name("Pouria") { |u| u.id = 5; u.picture = "assets/Pouria.jpg" }
User.find_or_create_by_name("M-reza") { |u| u.id = 5; u.picture = "assets/M-reza.jpg" }
