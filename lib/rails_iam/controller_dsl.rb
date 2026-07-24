module RailsIam
  module ControllerDsl
    extend ActiveSupport::Concern

    class_methods do
      def rails_iam(*features)
        features.each do |feature|
          case feature.to_sym
          when :authentication
            include RailsIam::Authentication::Authenticatable

          when :authorization
            include RailsIam::Authorization::Authorizable

          else
            raise ArgumentError, "Unknown RailsIam feature: #{feature.inspect}"
          end
        end
      end
    end
  end
end
