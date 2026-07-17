# frozen_string_literal: true

module RailsIam
  class RolePermission < ApplicationRecord
    belongs_to :permission, class_name: "RailsIam::Permission"
    belongs_to :role, class_name: "RailsIam::Role"

    validates :permission_id, uniqueness: { scope: :role_id }
  end
end
