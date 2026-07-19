# frozen_string_literal: true

module RailsIam
  class Role < ApplicationRecord
    has_many :user_roles, dependent: :destroy, class_name: "RailsIam::UserRole"
    has_many :users, through: :user_roles, class_name: RailsIam.configuration.user_class
    has_many :role_permissions, dependent: :destroy, class_name: "RailsIam::RolePermission"
    has_many :permissions, through: :role_permissions, class_name: "RailsIam::Permission"

    validates :name, presence: true, uniqueness: true

    normalizes :name, with: ->(code) { code.to_s.downcase.strip }
  end
end
