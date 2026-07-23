# frozen_string_literal: true

module RailsIam
  module Authentication
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        before_action :authenticate!
      end

      def current_user
        RailsIam::Authentication::Current.user
      end

      private

      def authenticate!
        RailsIam::Authentication::Current.user = RailsIam::Authentication::Authenticator.call(request)
      end
    end
  end
end
