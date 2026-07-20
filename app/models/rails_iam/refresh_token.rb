# frozen_string_literal: true

module RailsIam
  class RefreshToken < ApplicationRecord
    belongs_to :user, class_name: RailsIam.configuration.user_class
  end
end
