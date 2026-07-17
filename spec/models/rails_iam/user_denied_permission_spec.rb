# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::UserDeniedPermission, type: :model do
  subject { create(:user_denied_permission) }

  describe "associations" do
    it { is_expected.to belong_to(:permission).class_name("RailsIam::Permission") }
    it { is_expected.to belong_to(:user).class_name("RailsIam::User") }
  end
end
