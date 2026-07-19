# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsIam::Authorization::Authorizer do
  subject(:authorize!) do
    described_class.call(
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

  context 'when nothing is required' do
    it 'returns true' do
      expect(authorize!).to be(true)
    end
  end

  context 'when only role authorization succeeds' do
    before do
      assign_role(
        user:,
        role: create_role('admin'),
      )
    end

    let(:required_roles) { ['admin'] }

    it 'returns true' do
      expect(authorize!).to be(true)
    end
  end

  context 'when only role authorization fails' do
    let(:required_roles) { ['admin'] }

    it 'raises MissingRoleError' do
      expect do
        authorize!
      end.to raise_error(
        RailsIam::Authorization::Exceptions::MissingRoleError,
      )
    end
  end

  context 'when only permission authorization succeeds' do
    before do
      grant_user_permission(
        user:,
        permission_code: 'user:view',
      )
    end

    let(:required_permissions) do
      ['user:view']
    end

    it 'returns true' do
      expect(authorize!).to be(true)
    end
  end

  context 'when permission authorization fails' do
    let(:required_permissions) do
      ['user:view']
    end

    it 'raises MissingPermissionError' do
      expect do
        authorize!
      end.to raise_error(
        RailsIam::Authorization::Exceptions::MissingPermissionError,
      )
    end
  end

  context 'when both role and permission are required' do
    before do
      permission =
        assign_role_with_permission(
          user:,
          role_name: 'admin',
          permission_code: 'user:view',
        )

      expect(permission).to be_present
    end

    let(:required_roles) do
      ['admin']
    end

    let(:required_permissions) do
      ['user:view']
    end

    it 'returns true' do
      expect(authorize!).to be(true)
    end
  end

  context 'when role succeeds but permission fails' do
    before do
      assign_role(
        user:,
        role: create_role('admin'),
      )
    end

    let(:required_roles) do
      ['admin']
    end

    let(:required_permissions) do
      ['user:view']
    end

    it 'raises MissingPermissionError' do
      expect do
        authorize!
      end.to raise_error(
        RailsIam::Authorization::Exceptions::MissingPermissionError,
      )
    end
  end

  context 'when permission succeeds but role fails' do
    before do
      grant_user_permission(
        user:,
        permission_code: 'user:view',
      )
    end

    let(:required_roles) do
      ['admin']
    end

    let(:required_permissions) do
      ['user:view']
    end

    it 'raises MissingRoleError' do
      expect do
        authorize!
      end.to raise_error(
        RailsIam::Authorization::Exceptions::MissingRoleError,
      )
    end
  end

  context 'when permission is denied' do
    before do
      permission =
        grant_user_permission(
          user:,
          permission_code: 'user:view',
        )

      deny_user_permission(
        user:,
        permission:,
      )
    end

    let(:required_permissions) do
      ['user:view']
    end

    it 'raises MissingPermissionError' do
      expect do
        authorize!
      end.to raise_error(
        RailsIam::Authorization::Exceptions::MissingPermissionError,
      )
    end
  end
end
