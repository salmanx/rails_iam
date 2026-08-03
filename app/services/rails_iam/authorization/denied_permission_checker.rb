# frozen_string_literal: true

module RailsIam
  module Authorization
    class DeniedPermissionChecker < RailsIam::RailsIamService
      def initialize(context)
        super()
        @context = context
      end

      def call
        return true if denied_permissions.empty?

        raise RailsIam::Authorization::Exceptions::MissingPermissionError.new(
          required: denied_permissions,
        )
      end

      private

      def denied_permissions
        permissions = @context.permissions_for_check

        denied =
          @context.resolved_permissions.denied_codes

        permissions.select do |permission|
          denied.include?(permission)
        end
      end
    end
  end
end
