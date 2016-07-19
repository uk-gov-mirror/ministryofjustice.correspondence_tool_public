FactoryGirl.define do
  factory :correspondence do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    email_confirmation { email }
    type 'Freedom of Information Request'
    topic 'Prisons'
    message { Faker::Lorem.paragraph(1) }
  end
end
