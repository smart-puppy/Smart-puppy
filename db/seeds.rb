require 'faker'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Cleaning up the database..."

JobSkill.destroy_all
Job.destroy_all
Skill.destroy_all
User.destroy_all

puts "Reseeding the seeds file"

# Create job seeker users
50.times do |i|
  User.create!(
    email: Faker::Internet.email,
    password: Devise.friendly_token,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    username: Faker::Internet.username,
    age: rand(18..65),
    phone_number: Faker::PhoneNumber.cell_phone,
    biography: Faker::Lorem.paragraph(sentence_count: 3),
    industry: Faker::Job.field,
    job_position: Faker::Job.title,
    location: Faker::Address.city,
    education: Faker::Educator.course,
    business: false
  )
end

# Create business users
25.times do |i|
  User.create!(
    email: Faker::Internet.email,
    password: Devise.friendly_token,
    business: true,
    username: Faker::Internet.username,
    phone_number: Faker::PhoneNumber.cell_phone,
    biography: Faker::Company.bs,
    industry: Faker::Company.industry,
    location: Faker::Address.city
  )
end

10.times do |i|
  Job.create!(
    title: Faker::Job.title,
    description: Faker::Lorem.paragraph(sentence_count: 4),
    company_name: Faker::Company.name,
    requirements: Faker::Job.key_skill,
    location: Faker::Address.city,
    user: User.all.sample
  )
end

50.times do |i|
  Skill.create!(
    name: Faker::Job.key_skill
  )
end

50.times do |i|
  JobSkill.create!(
    job: Job.all.sample,
    skill: Skill.all.sample
  )
end

50.times do |i|
  UserSkill.create!(
    user: User.all.sample,
    skill: Skill.all.sample
  )
end

puts "Database reseeded!"
