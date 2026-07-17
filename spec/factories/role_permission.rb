# frozen_string_literal: true

FactoryBot.define do
  factory :role_permission, class: "RailsIam::RolePermission" do
    association :role

    association :permission
  end
end
