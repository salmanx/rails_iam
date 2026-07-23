# frozen_string_literal: true

module RailsIam
  module Authentication
    class CookieExtractor < RailsIam::RailsIamService
      def initialize(request)
        super()
        @request = request
      end

      def call
        request.cookie_jar.encrypted[access_token_key]
      end

      private

      attr_reader :request
    end

    class BearerExtractor < RailsIam::RailsIamService
      def initialize(request)
        super()
        @request = request
      end

      def call
        authorization = request.headers["Authorization"]
        return if authorization.blank?

        scheme, token = authorization.split(" ", 2)

        scheme == "Bearer" ? token : nil
      end

      private

      attr_reader :request
    end

    class TokenExtractor < RailsIam::RailsIamService
      def initialize(request)
        super()
        @request = request
      end

      def call
        extractor.call(request)
      end

      private

      def extractor
        # Explicitly pick the extractor based on the incoming request signature
        if authentication_strategies.include?(:bearer) && request.headers["Authorization"]&.start_with?("Bearer ")
          BearerExtractor
        else
          CookieExtractor
        end
      end

      attr_reader :request
    end
  end
end
