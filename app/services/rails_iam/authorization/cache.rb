# frozen_string_literal: true

module RailsIam
  module Authorization
    class Cache
      ROLES = :roles
      PERMISSIONS = :permissions

      class << self
        def read_or_write(namespace, user_id, &block)
          cache.fetch(
            cache_key(namespace, user_id),
            expires_in: RailsIam.configuration.authorization.cache_ttl,
            &block
          )
        end

        def delete(namespace, user_id)
          cache.delete(cache_key(namespace, user_id))
        end

        def delete_all(user_id)
          delete(Cache::ROLES, user_id)
          delete(Cache::PERMISSIONS, user_id)
        end

        private

        def cache
          RailsIam.configuration.authorization.cache_store || Rails.cache
        end

        def cache_key(namespace, user_id)
          "rails_iam:#{namespace}:#{user_id}"
        end
      end
    end
  end
end
