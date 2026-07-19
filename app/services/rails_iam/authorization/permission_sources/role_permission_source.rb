# frozen_string_literal: true

module RailsIam
  module Authorization
    module PermissionSources
      class RolePermissionSource < RailsIam::RailsIamService
        def initialize(user)
          super()
          @user = user
        end

        def call
          rows = []

          user
            .roles
            .includes(:permissions)
            .find_each do |role|
            role.permissions.each do |permission|
              rows << {
                code: permission.code,
                source: :role,
                role: role.name,
              }
            end
          end

          rows
        end

        private

        attr_reader :user
      end
    end
  end
end
