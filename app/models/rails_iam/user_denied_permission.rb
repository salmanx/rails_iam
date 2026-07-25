# frozen_string_literal: true

module RailsIam
  class UserDeniedPermission < ApplicationRecord
    belongs_to :permission, class_name: "RailsIam::Permission"
    belongs_to :user, class_name: RailsIam.configuration.user_class

    validates :permission_id, uniqueness: { scope: :user_id }

    after_commit -> { RailsIam::Authorization::Cache.delete_all(user_id) }
  end
end
