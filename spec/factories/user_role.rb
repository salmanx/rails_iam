# frozen_string_literal: true

FactoryBot.define do
  factory :user_role, class: "RailsIam::UserRole" do
    association :user

    association :role
  end
end
