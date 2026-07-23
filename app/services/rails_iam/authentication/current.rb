# frozen_string_literal: true

module RailsIam
  module Authentication
    class Current < ActiveSupport::CurrentAttributes
      attribute :user
    end
  end
end
