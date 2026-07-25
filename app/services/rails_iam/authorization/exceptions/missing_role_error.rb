# frozen_string_literal: true

module RailsIam
  module Authorization
    module Exceptions
      class MissingRoleError < AuthorizationError
        include RailsIam::ConfigLoader

        def initialize(required:, actual:)
          formatter = missing_role_error

          message = case formatter
                    # 1. If the user configured a plain String, use it directly
                    when String
                      formatter
                    # 2. If it's a Proc/Lambda, inspect its argument requirements
                    when Proc
                      if formatter.arity.zero?
                        # The user defined a lambda with no parameters: e.g., -> { "Access Denied" }
                        formatter.call
                      else
                        # The user defined a parameterized lambda: e.g., ->(required:, actual:) { ... }
                        formatter.call(required: required, actual: actual)
                      end
                    # 3. Fallback safeguard if config is empty or invalid type
                    else
                      "Required role: #{required.join(', ')}, actual: #{actual.join(', ')}"
                    end

          super(message)
        end
      end
    end
  end
end
