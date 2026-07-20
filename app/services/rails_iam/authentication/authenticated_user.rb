# frozen_string_literal: true

module RailsIam
  module Authentication
    AuthenticatedUser = Data.define(
      :user,
      :access_token,
      :access_token_expires_in,
      :refresh_token,
      :refresh_token_expires_in,
    )
  end
end
