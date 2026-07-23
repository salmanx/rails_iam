# frozen_string_literal: true

module RailsIam
  class User < ApplicationRecord
    has_secure_password

    has_many :user_roles, dependent: :destroy, class_name: "RailsIam::UserRole"
    has_many :roles, through: :user_roles, class_name: "RailsIam::Role"
    has_many :user_permissions, dependent: :destroy, class_name: "RailsIam::UserPermission"
    has_many :granted_permissions, through: :user_permissions, source: :permission
    has_many :user_denied_permissions, dependent: :destroy, class_name: "RailsIam::UserDeniedPermission"
    has_many :denied_permissions, through: :user_denied_permissions, source: :permission
    has_many :refresh_tokens, dependent: :destroy, class_name: "RailsIam::RefreshToken"

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6, maximum: 20 }, if: :password

    normalizes :email, with: ->(email) { email.to_s.downcase.strip }

    def as_json(options = {})
      super.except("password_digest")
    end
  end
end
