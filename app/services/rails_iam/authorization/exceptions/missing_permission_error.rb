# frozen_string_literal: true

module RailsIam
  module Authorization
    module Exceptions
      class MissingPermissionError < AuthorizationError
        include RailsIam::ConfigLoader

        def initialize(required:)
          formatter = missing_permission_error

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
                        formatter.call(required: required)
                      end
                    # 3. Fallback safeguard if config is empty or invalid type
                    else
                      "Missing permission(s): #{required.join(', ')}"
                    end

          super(message)
        end
      end
    end
  end
end
