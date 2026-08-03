# frozen_string_literal: true

#
# RailsIam Configuration
#
# Use this file to configure how your application handles authentication,
# authorization scopes, JWT token properties, caching, and error handling.
#
RailsIam.configure do |config|
  # =========================================================================
  # Host Application Integration
  # =========================================================================

  # - The class name of your main User/Account model which will be used to login
  # - It's been used throughout RailsIam for authentication, authorization, associations and user lookup.
  # - Configure this only if you use a different model
  #   or you have your own authentication mechanism (devise or jwt/bcrypt)
  # - Default: 'RailsIam::User'
  # config.user_class = 'RailsIam::User'

  # - The method name your controllers use to look up the currently active session user.
  # - Default: :current_user
  # config.current_user_method = :current_user

  # - The performer method that rails_iam use to track who creates and assign role/permission
  # - Support symbol and proc
  # - Default: :email
  # config.audit_performer_method = :email

  # =========================================================================
  # Authentication Settings (config.authentication)
  # =========================================================================

  # - The key used when storing or reading the access token from cookies or parameters.
  # - Default: 'access_token'
  # config.authentication.access_token_key = 'access_token'

  # - The key used when storing or reading the long-lived refresh token.
  # - Default: 'refresh_token'
  # config.authentication.refresh_token_key = 'refresh_token'

  # - Supported authentication delivery strategies.
  # - Options: [:cookie], [:bearer], or combined [:cookie, :bearer]
  # - For :bearer, the gem expects the token in authorization header with `Bearer your_token`
  # - Default: [:cookie]
  # config.authentication.authentication_strategies = [:cookie] # httponly

  # - Cookie configuration (Web / Cookie-based Strategy)
  # - Configure the security and behavior properties for session cookies issued by
  # - the RailsIam engine. These settings strictly apply when using the :cookie authentication strategy.
  # - Default: { httponly: true, secure: Rails.env.production?, same_site: :lax, }
  # config.authentication.cookie_options = { httponly: true, secure: Rails.env.production?, same_site: :lax, }

  # - Refresh Token Transport, only needed if authentication_strategies uses :bearer
  # - Determines how RailsIam receives the refresh token for
  #   refresh and sign-out requests when using bearer authentication.
  # - Will use the same @refresh_token_key to get the header
  #   i,e: request.get_header(refresh_token_key.upcase) -> HTTP_X_REFRESH_TOKEN
  # - Options: :header, :request_body
  # - Default: :header
  # config.authentication.refresh_token_transport = :header

  # - Session persistence limit strategy.
  #   [:single] - Forces one active device/session per user at any time (invalidates old tokens).
  #   [:multi]  - Allows concurrent login sessions across multiple devices or browsers.
  # - Default: :single
  # config.authentication.session_strategy = :single

  #
  # Built-in Authentication Routes
  #
  # - Routes exposed by RailsIam when using its built-in authentication
  #   controllers. Put `nil` if  you don't  want RailsIam to provide
  #   the HTTP sign-in, sign-out and refresh token endpoints. You don't need to add
  #   anything to your host application. RailsIam  will map this routes
  #   to your host application i,e: example.com/auth/sign_in
  #
  # You can also:
  # - Use Devise (or another authentication library) and leave these default nil.
  # - Build your own authentication controllers and use RailsIam's
  #   JWT encoder/decoder, refresh token services, or login/logout
  #   services without exposing the built-in routes.
  # - Mix both approaches (e.g. use RailsIam's sign-in route but your
  #   own sign-out route).
  # - Use nil if your application already have authentication routes
  # config.authentication.sign_in_path = '/auth/sign_in'
  # config.authentication.sign_out_path = '/auth/sign_out'
  # config.authentication.refresh_token_path = '/auth/refresh

  # - Lifespan for the Access Token used
  # - Default: 15.minutes
  # config.authentication.access_token_expires_in = 15.minutes

  # - Lifespan for the Refresh Token used to request replacement access tokens.
  # - Default: 30.days
  # config.authentication.refresh_token_expires_in = 30.days

  # - Custom system error messages emitted during authentication edge cases.
  # - Configure the error messages if you need different messages
  # config.authentication.token_error          = 'The provided authentication token is invalid or malformed.'
  # config.authentication.token_expired_error  = 'The authentication token has expired. Please re-authenticate.'
  # config.authentication.authentication_error = 'Invalid email or password.'
  # config.authentication.authentication_strategy_error = 'Unknown authentication strategy. Please configure it from rails_iam initializer'
  # config.authentication.session_strategy_error = 'Unknown session strategy. Please configure it from rails_iam initializer'
  # config.authentication.refresh_token_transport_error = 'Unknown refresh token transport. Please configure it from rails_iam initializer'

  # =========================================================================
  # Authorization & Cache Settings (config.authorization)
  # =========================================================================

  # - Custom formatters for policy denial messaging.
  # - Accepts plain Strings, dynamic blocks, or Lambdas with positional keywords.
  #
  # config.authorization.missing_role_error = lambda do |required:, actual:|
  #   "Missing roles: #{required}. You only have: #{actual}"
  # end
  #
  # config.authorization.missing_permission_error = lambda do |required:|
  #   "Missing permission(s): #{required.join(', ')}"
  # end

  # - Error message if permission is not applied on endpoint
  # - Example: No authorization rule for users#show
  # config.authorization.authorization_rule_error = "No authorization rule for "

  # - The store engine to cache resolved roles and permissions queries for low DB footprints.
  # - Default: Rails.cache
  # config.authorization.cache_store = Rails.cache

  # - Lifespan duration for records cached within the authorization engine layer.
  # - Default: 15.minutes
  # config.authorization.cache_ttl = 15.minutes

  # - Controller namespaces excluded from automatic authorization.
  # - Use this when a third-party library or Rails engine (such as Devise, or another mounted engine) provides controllers
  # - that inherit from your ApplicationController but should not be subject to RailsIam authorization.
  # - Example: [/\ADevise::/, /\ARailsIam::/]
  # config.authorization.excluded_controller_patterns = []

  # =========================================================================
  # JWT Cryptography Settings (config.jwt)
  # =========================================================================

  # - Secret verification string used to sign security tokens.
  # - Default: ENV['JWT_SECRET'] or Rails.application.secret_key_base
  # config.jwt.secret = ENV['JWT_SECRET']

  # - Digital signature algorithm category mapping.
  # - Default: 'HS256'
  # config.jwt.algorithm = 'HS256'

  # - Jwt expiry, default to 15 minutes, same as access token in cookie expiry
  # config.jwt.jwt_expires_in = 15.minutes

  # - Optional security claim validations (RFC 7519 standard targets).
  # - Leave nil to disable strict validation checks.
  # - You can also dynamically set them in `extra_claims` at `JwtEncoder`
  # config.jwt.issuer   = 'https://yourdomain.com'
  # config.jwt.audience = 'your_application_client_id'
end
