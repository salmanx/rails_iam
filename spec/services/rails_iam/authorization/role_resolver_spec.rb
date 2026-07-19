# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsIam::Authorization::RoleResolver do
  describe '.call' do
    subject(:resolved_roles) { described_class.call(user) }

    let(:user) { create(:user) }

    context 'when the user has no roles' do
      it 'returns an empty set' do
        expect(resolved_roles).to eq(Set.new)
      end
    end

    context 'when the user has one role' do
      before do
        role = create(:role, name: 'admin')
        create(:user_role, user:, role:)
      end

      it 'returns the role name' do
        expect(resolved_roles).to eq(Set['admin'])
      end
    end

    context 'when the user has multiple roles' do
      before do
        create(:user_role, user:, role: create(:role, name: 'admin'))
        create(:user_role, user:, role: create(:role, name: 'hr'))
        create(:user_role, user:, role: create(:role, name: 'sales'))
      end

      it 'returns every role' do
        expect(resolved_roles).to eq(
          Set[
            'admin',
            'hr',
            'sales',
          ],
        )
      end
    end

    context 'when duplicate role names exist' do
      before do
        create(:user_role, user:, role: create(:role, name: 'admin'))
      end

      it 'returns a unique set' do
        expect(resolved_roles.size).to eq(1)
      end
    end

    it 'returns a frozen set' do
      expect(resolved_roles).to be_frozen
    end
  end
end
