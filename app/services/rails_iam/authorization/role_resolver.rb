# frozen_string_literal: true

module RailsIam
  module Authorization
    class RoleResolver < RailsIam::RailsIamService
      def initialize(user)
        super()
        @user = user
      end

      def call
        Cache.read_or_write(Cache::ROLES, user.id) do
          resolve
        end
      end

      private

      attr_reader :user

      def resolve
        user.roles
            .pluck(:name)
            .map!(&:to_s)
            .to_set
            .freeze
      end
    end
  end
end
