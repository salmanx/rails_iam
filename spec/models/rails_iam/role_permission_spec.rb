# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::RolePermission, type: :model do
  subject { create(:role_permission) }

  describe "associations" do
    it { is_expected.to belong_to(:permission).class_name("RailsIam::Permission") }
    it { is_expected.to belong_to(:role).class_name("RailsIam::Role") }
  end

  describe 'callbacks' do
    describe 'after_commit :clear_user_permission_caches' do
      let(:role) { create(:role) }
      let(:permission) { create(:permission) }
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      before do
        role.users << [user1, user2]
        allow(RailsIam::Authorization::Cache).to receive(:delete_all)
      end

      it 'clears permission caches for all users tied to the role when created' do
        create(:role_permission, role: role, permission: permission)

        expect(RailsIam::Authorization::Cache).to have_received(:delete_all).with(user1.id)
        expect(RailsIam::Authorization::Cache).to have_received(:delete_all).with(user2.id)
      end
    end
  end
end
