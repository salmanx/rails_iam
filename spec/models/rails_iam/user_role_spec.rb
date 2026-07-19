# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::UserRole, type: :model do
  subject { create(:user_role) }

  describe "associations" do
    it { is_expected.to belong_to(:user).class_name("RailsIam::User") }
    it { is_expected.to belong_to(:role).class_name("RailsIam::Role") }
  end
end
