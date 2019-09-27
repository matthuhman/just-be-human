FactoryBot.define do
  factory :notification do
    recipient_id { 1 }
    actor_id { 1 }
    read_at { "2019-09-27 09:32:05" }
    action { "MyString" }
    notifiable_id { 1 }
    notifiable_type { "MyString" }
  end
end
