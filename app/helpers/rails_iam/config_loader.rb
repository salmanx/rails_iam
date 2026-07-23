# frozen_string_literal: true

module RailsIam
  module ConfigLoader
    extend Forwardable

    def user_class
      @user_class ||= RailsIam.configuration.user_class.constantize
    end

    # Authentication configuration
    def_delegators :"RailsIam.configuration.authentication",
                   :access_token_key,
                   :refresh_token_key,
                   :cookie_options,
                   :token_error,
                   :token_expired_error,
                   :authentication_error,
                   :authentication_strategy_error,
                   :session_strategy_error,
                   :refresh_token_transport_error,
                   :refresh_token_expires_in,
                   :access_token_expires_in
    def session_strategy
      @session_strategy ||= RailsIam.configuration.authentication.session_strategy&.to_sym
    end

    def authentication_strategies
      @authentication_strategies ||= Array(RailsIam.configuration.authentication.authentication_strategies).map(&:to_sym)
    end

    def refresh_token_transport
      @refresh_token_transport ||= RailsIam.configuration.authentication.refresh_token_transport.to_sym
    end

    # Authorization configuration
    def_delegators :"RailsIam.configuration.authorization",
                   :missing_permission_error,
                   :missing_role_error

    def authorization_rule_error
      error = RailsIam.configuration.authorization.authorization_rule_error
      "#{error.to_s.strip.ljust(1)} #{controller_name}##{action_name}"
    end

    # Jwt configuration
    def jwt_algorithm
      RailsIam.configuration.jwt.algorithm
    end

    def jwt_expiry
      RailsIam.configuration.jwt.jwt_expires_in
    end

    def jwt_issuer
      RailsIam.configuration.jwt.issuer
    end

    def jwt_audience
      RailsIam.configuration.jwt.audience
    end

    def jwt_secret_key
      RailsIam.configuration.jwt.secret
    end
  end
end
