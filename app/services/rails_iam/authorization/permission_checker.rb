# frozen_string_literal: true

module RailsIam
  module Authorization
    class PermissionChecker < RailsIam::RailsIamService
      def initialize(context)
        super()
        @context = context
      end

      def call
        return true if @context.required_permissions.empty?

        success =
          case @context.permission_match
          when :any
            @context.required_permissions.any? do |permission|
              @context.resolved_permissions.include?(permission)
            end

          when :all
            @context.required_permissions.all? do |permission|
              @context.resolved_permissions.include?(permission)
            end

          else
            raise ArgumentError, "Unknown permission_match #{@context.permission_match}"
          end

        return true if success

        raise RailsIam::Authorization::Exceptions::MissingPermissionError.new(
          required: @context.required_permissions,
        )
      end
    end
  end
end
