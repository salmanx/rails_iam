# frozen_string_literal: true

FactoryBot.define do
  factory :user_denied_permission, class: "RailsIam::UserDeniedPermission" do
    association :user

    association :permission
  end
end
