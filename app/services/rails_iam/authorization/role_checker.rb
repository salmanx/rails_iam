# frozen_string_literal: true

module RailsIam
  module Authorization
    class RoleChecker < RailsIam::RailsIamService
      def initialize(context)
        super()
        @context = context
      end

      def call
        return true if @context.required_roles.empty?

        success =
          case @context.role_match
          when :any
            (@context.roles.to_a & @context.required_roles).any?

          when :all
            (@context.required_roles - @context.roles.to_a).empty?

          else
            raise ArgumentError, "Unknown role_match #{@context.role_match}"
          end

        return true if success

        raise RailsIam::Authorization::Exceptions::MissingRoleError.new(
          required: @context.required_roles,
          actual: @context.roles,
        )
      end
    end
  end
end
