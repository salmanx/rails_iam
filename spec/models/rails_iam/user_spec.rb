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
    it { is_expected.to have_many(:refresh_tokens).class_name('RailsIam::RefreshToken').dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.with_allowed_permissions' do
      it 'includes user_permissions and their permission relationship' do
        expect(described_class.with_allowed_permissions.includes_values).to include(user_permissions: :permission)
      end
    end

    describe '.with_denied_permissions' do
      it 'includes user_denied_permissions and their permission relationship' do
        expect(described_class.with_denied_permissions.includes_values).to include(user_denied_permissions: :permission)
      end
    end

    describe '.with_authorization' do
      it 'eager loads roles, granted permissions, and denied permissions structures' do
        expect(described_class.with_authorization.includes_values).to include(
          roles: :permissions,
          user_permissions: :permission,
          user_denied_permissions: :permission,
        )
      end
    end
  end

  describe '#role_names' do
    subject(:role_names) { user.role_names }

    let(:user) { create(:user) }

    context 'when user has no roles' do
      it 'returns an empty array' do
        expect(role_names).to eq([])
      end
    end

    context 'when user has one role' do
      before do
        role = create(:role, name: 'admin')
        create(:user_role, user:, role:)
      end

      it 'returns the role name' do
        expect(role_names).to contain_exactly('admin')
      end
    end

    context 'when user has multiple roles' do
      before do
        admin = create(:role, name: 'admin')
        hr = create(:role, name: 'hr')

        create(:user_role, user:, role: admin)
        create(:user_role, user:, role: hr)
      end

      it 'returns all role names' do
        expect(role_names).to contain_exactly('admin', 'hr')
      end
    end
  end

  describe '#permission_codes' do
    subject(:permission_codes) { user.permission_codes }

    let(:user) { create(:user) }

    context 'when user has no permissions' do
      it 'returns an empty array' do
        expect(permission_codes).to eq([])
      end
    end

    context 'when user has a direct permission' do
      before do
        permission = create(:permission, code: 'user:view')
        create(:user_permission, user:, permission:)
      end

      it 'returns the permission code' do
        expect(permission_codes).to contain_exactly('user:view')
      end
    end

    context 'when permission comes from a role' do
      before do
        role = create(:role, name: 'admin')
        permission = create(:permission, code: 'user:view')

        create(:user_role, user:, role:)
        create(:role_permission, role:, permission:)
      end

      it 'returns the permission code' do
        expect(permission_codes).to contain_exactly('user:view')
      end
    end

    context 'when user has both direct and role permissions' do
      before do
        role = create(:role, name: 'admin')

        view = create(:permission, code: 'user:view')
        update = create(:permission, code: 'user:update')

        create(:user_role, user:, role:)
        create(:role_permission, role:, permission: view)

        create(:user_permission, user:, permission: update)
      end

      it 'returns all effective permissions' do
        expect(permission_codes)
          .to contain_exactly('user:view', 'user:update')
      end
    end

    context 'when a permission is explicitly denied' do
      before do
        permission = create(:permission, code: 'user:view')

        create(:user_permission, user:, permission:)
        create(:user_denied_permission, user:, permission:)
      end

      it 'does not include the denied permission' do
        expect(permission_codes).to eq([])
      end
    end

    context 'when user has wildcard permission through a role' do
      before do
        role = create(:role, name: 'admin')
        permission = create(:permission, code: 'user:*')

        create(:user_role, user:, role:)
        create(:role_permission, role:, permission:)
      end

      it 'returns the wildcard permission' do
        expect(permission_codes).to contain_exactly('user:*')
      end
    end
  end
end
