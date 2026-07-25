# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::UserDeniedPermission, type: :model do
  subject { create(:user_denied_permission) }

  describe "associations" do
    it { is_expected.to belong_to(:permission).class_name("RailsIam::Permission") }
    it { is_expected.to belong_to(:user).class_name("RailsIam::User") }
  end



  describe 'callbacks' do
    describe 'after_commit inline lambda' do
      let(:user) { create(:user) }
      let(:permission) { create(:permission) }

      before do
        allow(RailsIam::Authorization::Cache).to receive(:delete_all)
      end

      it 'clears the specific user permission cache upon commit' do
        create(:user_denied_permission, user: user, permission: permission)

        expect(RailsIam::Authorization::Cache).to have_received(:delete_all).with(user.id)
      end
    end
  end  
end
