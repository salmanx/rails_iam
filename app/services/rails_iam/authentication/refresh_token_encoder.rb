# frozen_string_literal: true

module RailsIam
  module Authentication
    class RefreshTokenEncoder
      def self.call
        SecureRandom.hex(64)
      end
    end
  end
end
