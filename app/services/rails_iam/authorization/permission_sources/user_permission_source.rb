# frozen_string_literal: true

module RailsIam
  module Authorization
    module PermissionSources
      class UserPermissionSource < RailsIam::RailsIamService
        def initialize(user)
          super()

          @user = user
        end

        def call
          user.user_permissions.includes(:permission).map do |record|
            {
              code: record.permission.code,
              source: :user,
            }
          end
        end

        private

        attr_reader :user
      end
    end
  end
end
