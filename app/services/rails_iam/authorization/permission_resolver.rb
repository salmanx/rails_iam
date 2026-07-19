# frozen_string_literal: true

module RailsIam
  module Authorization
    PermissionMetadata = Data.define(
      :source,
      :role,
    )

    class PermissionResolver < RailsIam::RailsIamService
      ALLOW_SOURCES = [
        Authorization::PermissionSources::RolePermissionSource,
        Authorization::PermissionSources::UserPermissionSource,
      ].freeze

      DENY_SOURCES = [
        Authorization::PermissionSources::UserDeniedPermissionSource,
      ].freeze

      def initialize(user)
        super()

        @user = user
      end

      def call
        Cache.read_or_write(:permissions, user.id) do
          resolve
        end
      end

      private

      attr_reader :user

      def resolve
        allowed_codes = Set.new
        denied_codes = Set.new
        metadata = {}

        # Resolve allowed permissions
        ALLOW_SOURCES.each do |source|
          source.call(@user).each do |row|
            allowed_codes << row[:code]

            metadata[row[:code]] ||= []

            metadata[row[:code]] << PermissionMetadata.new(
              source: row[:source],
              role: row[:role],
            )
          end
        end

        # Resolve denied permissions
        DENY_SOURCES.each do |source|
          source.call(@user).each do |row|
            denied_codes << row[:code]
          end
        end

        ResolvedPermissions.new(
          allowed_codes: allowed_codes,
          denied_codes: denied_codes,
          metadata: metadata,
        )
      end
    end
  end
end
