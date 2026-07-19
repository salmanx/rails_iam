# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsIam::Authorization::AuthorizationContext do
  subject(:context) do
    described_class.new(
      user: user,
      required_roles: required_roles,
      required_permissions: required_permissions,
      role_match: role_match,
      permission_match: permission_match,
    )
  end

  let(:user) { create(:user) }
  let(:required_roles) { [] }
  let(:required_permissions) { [] }
  let(:role_match) { :any }
  let(:permission_match) { :all }

  describe '#initialize' do
    it 'stores the user' do
      expect(context.user).to eq(user)
    end

    it 'normalizes required roles' do
      expect(context.required_roles).to eq([])
    end

    it 'normalizes required permissions' do
      expect(context.required_permissions).to eq([])
    end

    it 'stores role_match' do
      expect(context.role_match).to eq(:any)
    end

    it 'stores permission_match' do
      expect(context.permission_match).to eq(:all)
    end
  end

  context 'when required roles are symbols' do
    let(:required_roles) { %i[admin hr] }

    it 'converts them to strings' do
      expect(context.required_roles).to eq(%w[admin hr])
    end
  end

  context 'when required permissions are symbols' do
    let(:required_permissions) do
      %i[user:view user:update]
    end

    it 'converts them to strings' do
      expect(context.required_permissions).to eq(
        ['user:view', 'user:update'],
      )
    end
  end

  context 'when user has roles' do
    before do
      assign_role(user:, role: create_role('admin'))
    end

    it 'loads resolved roles' do
      expect(context.roles).to eq(Set['admin'])
    end
  end

  context 'when user has permissions' do
    before do
      grant_user_permission(
        user:,
        permission_code: 'user:view',
      )
    end

    it 'loads resolved permissions' do
      expect(
        context.resolved_permissions.include?('user:view'),
      ).to be(true)
    end
  end
end
