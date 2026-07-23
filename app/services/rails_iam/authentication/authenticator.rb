# frozen_string_literal: true

module RailsIam
  module Authentication
    class Authenticator < RailsIam::RailsIamService
      include RailsIam::ConfigLoader

      def initialize(request, raise_on_failure: true)
        super()
        @request = request
        @raise_on_failure = raise_on_failure
      end

      def call
        token = TokenExtractor.call(request)

        if token.blank?
          return nil unless @raise_on_failure

          raise RailsIam::Authentication::Exceptions::AuthenticationError, token_error
        end

        payload = JwtDecoder.call(token)

        user = User.find_by(id: payload[:sub])

        raise Authentication::Exceptions::AuthenticationError, token_error unless user

        user
      rescue JwtDecoder::InvalidToken => e
        raise Authentication::Exceptions::AuthenticationError, e.message # => token_error
      end

      private

      attr_reader :request
    end
  end
end
