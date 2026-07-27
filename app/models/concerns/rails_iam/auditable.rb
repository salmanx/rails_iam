# frozen_string_literal: true

module RailsIam
  # frozen_string_literal: true

  module Auditable
    extend ActiveSupport::Concern

    included do
      before_create :set_created_by, if: :created_by_column_present?
      before_destroy :set_deleted_by, if: :deleted_by_column_present?
      before_update :set_updated_by, if: :updated_by_column_present?
    end

    private

    def set_created_by
      self.created_by = performer if respond_to?(:created_by=)
    end

    def set_updated_by
      self.updated_by = performer if respond_to?(:updated_by=)
    end

    def set_deleted_by
      self.deleted_by = performer if respond_to?(:deleted_by=)
    end

    def performer
      user = RailsIam::Authentication::Current.user
      return if user.nil?

      method = RailsIam.configuration.audit_performer_method

      case method
      when Symbol
        user.public_send(method)
      when Proc
        method.call(user)
      else
        user.id
      end
    end

    def created_by_column_present?
      self.class.column_names.include?("created_by")
    end

    def deleted_by_column_present?
      self.class.column_names.include?("deleted_by")
    end

    def updated_by_column_present?
      self.class.column_names.include?("updated_by")
    end
  end
end
