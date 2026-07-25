# frozen_string_literal: true

require "rails_helper"

RSpec.describe RailsIam::UserRole, type: :model do
  subject { create(:user_role) }

  describe "associations" do
    it { is_expected.to belong_to(:user).class_name("RailsIam::User") }
    it { is_expected.to belong_to(:role).class_name("RailsIam::Role") }
  end

  describe 'callbacks' do
    describe 'after_commit inline lambda' do
      let(:user) { create(:user) }
      let(:role) { create(:role) }

      before do
        allow(RailsIam::Authorization::Cache).to receive(:delete_all)
      end

      it 'clears the specific user permission cache upon commit' do
        create(:user_role, user: user, role: role)

        expect(RailsIam::Authorization::Cache).to have_received(:delete_all).with(user.id)
      end
    end
  end

end
