# frozen_string_literal: true

module RailsIam
  module Authorization
    class ResolvedPermissions
      attr_reader :allowed_codes,
                  :denied_codes,
                  :metadata

      def initialize(
        allowed_codes:,
        denied_codes:,
        metadata:
      )
        @allowed_codes = allowed_codes.to_set.freeze
        @denied_codes = denied_codes.to_set.freeze
        @metadata = metadata.freeze
      end

      def include?(permission)
        permission = permission.to_s

        return false if denied?(permission)

        allowed?(permission)
      end

      def codes
        allowed_codes
      end

      def effective_codes
        @allowed_codes - @denied_codes
      end

      def explain(permission)
        metadata.fetch(permission.to_s, [])
      end

      private

      def allowed?(permission)
        match?(allowed_codes, permission)
      end

      def denied?(permission)
        match?(denied_codes, permission)
      end

      def match?(set, permission)
        return true if set.include?(permission)

        namespace = permission.split(":").first

        return true if set.include?("#{namespace}:*")

        return true if set.include?("*")

        false
      end
    end
  end
end
