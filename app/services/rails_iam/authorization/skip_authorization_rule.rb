# frozen_string_literal: true

module RailsIam
  module Authorization
    SkipAuthorizationRule = Data.define(
      :only,
      :except,
    ) do
      def matches?(action)
        action = action.to_sym

        return Array(only).map(&:to_sym).include?(action) if only.present?
        return Array(except).map(&:to_sym).exclude?(action) if except.present?

        true
      end
    end
  end
end
