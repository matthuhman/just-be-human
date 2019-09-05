# This will guess the User class
FactoryBot.define do
  factory :comment do
    content { FFaker::Lorem.sentence }
    # user
    # post
  end
end
