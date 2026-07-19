# frozen_string_literal: true

module RailsIam
  class Permission < ApplicationRecord
    has_many :role_permissions, dependent: :destroy, class_name: "RailsIam::RolePermission"
    has_many :roles, through: :role_permissions, class_name: "RailsIam::Role"
    has_many :user_permissions, dependent: :destroy, class_name: "RailsIam::UserPermission"
    has_many :users, through: :user_permissions, class_name: RailsIam.configuration.user_class

    validates :code, presence: true, uniqueness: true

    normalizes :code, with: ->(code) { code.to_s.downcase.strip }
  end
end
