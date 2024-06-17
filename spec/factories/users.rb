FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { 'password' }
    #   role { :user }
    #   jti { SecureRandom.uuid }
    end
end