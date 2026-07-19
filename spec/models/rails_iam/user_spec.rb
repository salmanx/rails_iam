# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::User, type: :model do
  subject { create(:user) }

  describe "password" do
    it { is_expected.to have_secure_password }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    context "when password is changing or present" do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(20) }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:user_roles).class_name("RailsIam::UserRole").dependent(:destroy) }
    it { is_expected.to have_many(:roles).through(:user_roles).class_name("RailsIam::Role") }

    it { is_expected.to have_many(:user_permissions).class_name("RailsIam::UserPermission").dependent(:destroy) }
    it { is_expected.to have_many(:granted_permissions).through(:user_permissions).source(:permission) }

    it { is_expected.to have_many(:user_denied_permissions).class_name("RailsIam::UserDeniedPermission").dependent(:destroy) }
    it { is_expected.to have_many(:denied_permissions).through(:user_denied_permissions).source(:permission) }
  end
end
