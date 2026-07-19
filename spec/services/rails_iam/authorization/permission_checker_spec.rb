# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsIam::Authorization::PermissionChecker do
  subject(:check_permission) { described_class.call(context) }

  let(:user) { create(:user) }

  let(:context) do
    RailsIam::Authorization::AuthorizationContext.new(
      user: user,
      required_permissions: required_permissions,
      permission_match: permission_match,
    )
  end

  let(:required_permissions) { [] }
  let(:permission_match) { :all }

  context 'when no permission is required' do
    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'when permission comes from role' do
    before do
      assign_role_with_permission(
        user: user,
        role_name: 'MANAGER',
        permission_code: 'user:view',
      )
    end

    let(:required_permissions) { ['user:view'] }

    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'when permission comes directly from user' do
    before do
      grant_user_permission(
        user: user,
        permission_code: 'user:update',
      )
    end

    let(:required_permissions) { ['user:update'] }

    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'when permission is denied' do
    before do
      permission =
        assign_role_with_permission(
          user: user,
          role_name: 'MANAGER',
          permission_code: 'user:update',
        )

      deny_user_permission(
        user: user,
        permission: permission,
      )
    end

    let(:required_permissions) { ['user:update'] }

    it 'raises MissingPermissionError' do
      expect do
        check_permission
      end.to raise_error(RailsIam::Authorization::Exceptions::MissingPermissionError)
    end
  end

  context 'with permission_match :any' do
    before do
      grant_user_permission(
        user: user,
        permission_code: 'user:view',
      )
    end

    let(:required_permissions) do
      %w[user:create user:view]
    end

    let(:permission_match) { :any }

    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'with permission_match :all' do
    before do
      grant_user_permission(
        user: user,
        permission_code: 'user:view',
      )

      grant_user_permission(
        user: user,
        permission_code: 'user:update',
      )
    end

    let(:required_permissions) do
      %w[user:view user:update]
    end

    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'with permission_match :all when one permission is missing' do
    before do
      grant_user_permission(
        user: user,
        permission_code: 'user:view',
      )
    end

    let(:required_permissions) do
      %w[user:view user:update]
    end

    it 'raises MissingPermissionError' do
      expect do
        check_permission
      end.to raise_error(RailsIam::Authorization::Exceptions::MissingPermissionError)
    end
  end

  context 'when wildcard permission exists' do
    before do
      grant_user_permission(
        user: user,
        permission_code: '*',
      )
    end

    let(:required_permissions) { ['invoice:approve'] }

    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'when namespace wildcard permission exists' do
    before do
      grant_user_permission(
        user: user,
        permission_code: 'user:*',
      )
    end

    let(:required_permissions) { ['user:update'] }

    it 'returns true' do
      expect(check_permission).to be(true)
    end
  end

  context 'when permission_match is invalid' do
    before do
      grant_user_permission(
        user: user,
        permission_code: 'user:view',
      )
    end

    let(:required_permissions) { ['user:view'] }
    let(:permission_match) { :unknown }

    it 'raises ArgumentError' do
      expect do
        check_permission
      end.to raise_error(ArgumentError)
    end
  end
end
