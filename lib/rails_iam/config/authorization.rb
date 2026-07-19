# frozen_string_literal: true

module RailsIam
  module Config
    class Authorization
      attr_accessor :missing_role_error,
                    :missing_permission_error,
                    :cache_store,
                    :cache_ttl

      def initialize
        # Accepts plain Strings, dynamic blocks, or Lambdas with positional keywords.
        @missing_role_error = lambda do |required:, actual:|
          "Missing roles: #{required.join(', ')}. You only have: #{actual.join(', ')}"
        end

        @missing_permission_error = lambda do |required:|
          "Missing permission(s): #{required.join(', ')}"
        end

        # The store engine to cache resolved roles and permissions queries for low DB footprints.
        @cache_store = Rails.cache
        @cache_ttl = 15.minutes
      end
    end
  end
end
