module RailsIam
  module ModelDsl
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_rails_iam_user
        include RailsIam::UserConcern
      end
    end
  end
end
