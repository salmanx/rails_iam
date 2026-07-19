# frozen_string_literal: true

module RailsIam
  module Authorization
    module PermissionSources
      class UserDeniedPermissionSource < RailsIam::RailsIamService
        def initialize(user)
          super()

          @user = user
        end

        def call
          user.user_denied_permissions.includes(:permission).map do |record|
            {
              code: record.permission.code,
              source: :user_denied,
              role: nil,
            }
          end
        end

        private

        attr_reader :user
      end
    end
  end
end
