# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::Role, type: :model do
  subject { create(:role) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
  end

  describe "associations" do
    it { is_expected.to have_many(:user_roles).class_name("RailsIam::UserRole").dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_roles) }
    it { is_expected.to have_many(:role_permissions).class_name("RailsIam::RolePermission").dependent(:destroy) }
    it { is_expected.to have_many(:permissions).through(:role_permissions) }
  end
end
