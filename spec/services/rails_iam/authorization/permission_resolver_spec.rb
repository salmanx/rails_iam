# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsIam::Authorization::PermissionResolver do
  describe '.call' do
    subject(:resolved) { described_class.call(user) }

    let(:user) { create(:user) }

    def assign_role_permission(role_name, permission_code)
      role = create(:role, name: role_name)
      permission = create(:permission, code: permission_code)

      create(:user_role, user:, role:)
      create(
        :role_permission,
        role:,
        permission:,
      )

      permission
    end

    def assign_user_permission(permission_code)
      permission = create(:permission, code: permission_code)

      create(
        :user_permission,
        user:,
        permission:,
      )

      permission
    end

    def deny_permission(permission)
      create(
        :user_denied_permission,
        user:,
        permission:,
      )
    end

    context 'when user has no permissions' do
      it 'returns an empty permission collection' do
        expect(resolved.effective_codes).to be_empty
      end
    end

    context 'when permission comes from role' do
      before do
        assign_role_permission(
          'manager',
          'user:view',
        )
      end

      it 'contains the permission' do
        expect(resolved.include?('user:view')).to be(true)
      end
    end

    context 'when permission comes directly from the user' do
      before do
        assign_user_permission(
          'user:update',
        )
      end

      it 'contains the permission' do
        expect(resolved.include?('user:update')).to be(true)
      end
    end

    # context 'when permission exists from role and user' do
    #   before do
    #     assign_role_permission(
    #       'manager',
    #       'user:view',
    #     )

    #     assign_user_permission(
    #       'user:view',
    #     )
    #   end

    #   it 'contains the permission only once' do
    #     expect(
    #       resolved.effective_codes.count { |p| p == 'user:view' },
    #     ).to eq(1)
    #   end
    # end

    context 'when permission is denied' do
      before do
        permission =
          assign_role_permission(
            'manager',
            'user:update',
          )

        deny_permission(permission)
      end

      it 'does not include the denied permission' do
        expect(
          resolved.include?('user:update'),
        ).to be(false)
      end
    end

    context 'when wildcard permission exists' do
      before do
        assign_user_permission('*')
      end

      it 'matches every permission' do
        expect(resolved.include?('anything')).to be(true)
      end
    end

    context 'when namespace wildcard exists' do
      before do
        assign_user_permission('user:*')
      end

      it 'matches user:view' do
        expect(resolved.include?('user:view')).to be(true)
      end

      it 'matches user:update' do
        expect(resolved.include?('user:update')).to be(true)
      end

      it 'does not match role:view' do
        expect(resolved.include?('role:view')).to be(false)
      end
    end

    context 'when requesting metadata' do
      before do
        assign_role_permission(
          'manager',
          'user:view',
        )
      end

      it 'returns the permission source' do
        metadata =
          resolved.explain('user:view')

        expect(metadata.first.source).to eq(:role)
      end

      it 'returns the role name' do
        metadata =
          resolved.explain('user:view')

        expect(metadata.first.role).to eq('manager')
      end
    end

    context 'when permission is unknown' do
      it 'returns false' do
        expect(
          resolved.include?(
            'invoice:approve',
          ),
        ).to be(false)
      end
    end
  end
end
