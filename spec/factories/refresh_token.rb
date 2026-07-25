FactoryBot.define do
  factory :refresh_token, class: 'RailsIam::RefreshToken' do
    sequence(:token_digest) { |n| "token_digest_#{n}" }
    expires_at  { 1.day.from_now }
    association :user
  end
end