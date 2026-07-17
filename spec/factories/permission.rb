# frozen_string_literal: true

FactoryBot.define do
  factory :permission, class: "RailsIam::Permission" do
    sequence(:code) { |n| "permission:#{n}" }
  end
end
