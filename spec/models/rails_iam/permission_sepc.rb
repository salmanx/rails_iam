# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::Permission, type: :model do
  subject { create(:permission) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).ignoring_case_sensitivity }
  end

  describe "associations" do
    it { is_expected.to have_many(:role_permissions).class_name("RailsIam::RolePermission").dependent(:destroy) }
    it { is_expected.to have_many(:roles).through(:role_permissions).class_name("RailsIam::Role") }
    it { is_expected.to have_many(:user_permissions).class_name("RailsIam::UserPermission").dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_permissions) }
  end
end
