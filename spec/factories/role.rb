# frozen_string_literal: true

FactoryBot.define do
  factory :role, class: "RailsIam::Role" do
    sequence(:name) { |n| "ROLE_#{n}" }
  end
end
