# frozen_string_literal: true

module RailsIam
  class User < ApplicationRecord
    has_secure_password
    include RailsIam::UserConcern

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6, maximum: 20 }, if: :password
    normalizes :email, with: ->(email) { email.to_s.downcase.strip }

    def as_json(options = {})
      super.except("password_digest")
    end
  end
end
