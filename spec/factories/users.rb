FactoryBot.define do
  factory :user do
    name {FFaker::Lorem.characters(rand(6..20))}
    password {FFaker::Lorem.characters(rand(6..20))}
    email {FFaker::Internet.email}
    role {1}
  end
end
