# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "RailsIam::User" do
    email { Faker::Internet.email[0..20] }

    password_digest { BCrypt::Password.create("password") }
  end
end
