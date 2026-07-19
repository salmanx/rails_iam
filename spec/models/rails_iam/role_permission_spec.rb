# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::RolePermission, type: :model do
  subject { create(:role_permission) }

  describe "associations" do
    it { is_expected.to belong_to(:permission).class_name("RailsIam::Permission") }
    it { is_expected.to belong_to(:role).class_name("RailsIam::Role") }
  end
end
