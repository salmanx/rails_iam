# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsIam::Authorization::RoleChecker do
  subject(:check_role) { described_class.call(context) }

  let(:user) { create(:user) }

  let(:context) do
    RailsIam::Authorization::AuthorizationContext.new(
      user: user,
      required_roles: required_roles,
      role_match: role_match,
    )
  end

  let(:required_roles) { [] }
  let(:role_match) { :any }

  context 'when no role is required' do
    it 'returns true' do
      expect(check_role).to be(true)
    end
  end

  context 'when user has the required role' do
    before do
      assign_role(user:, role: create_role('admin'))
    end

    let(:required_roles) { ['admin'] }

    it 'returns true' do
      expect(check_role).to be(true)
    end
  end

  context 'when user does not have the required role' do
    before do
      assign_role(user:, role: create_role('hr'))
    end

    let(:required_roles) { ['admin'] }

    it 'raises MissingRoleError' do
      expect do
        check_role
      end.to raise_error(RailsIam::Authorization::Exceptions::MissingRoleError)
    end
  end

  context 'with role_match :any' do
    before do
      assign_role(user:, role: create_role('hr'))
    end

    let(:required_roles) { %w[admin hr] }

    it 'returns true' do
      expect(check_role).to be(true)
    end
  end

  context 'with role_match :all' do
    before do
      assign_role(user:, role: create_role('admin'))
      assign_role(user:, role: create_role('hr'))
    end

    let(:required_roles) { %w[admin hr] }
    let(:role_match) { :all }

    it 'returns true' do
      expect(check_role).to be(true)
    end
  end

  context 'with role_match :all when one role is missing' do
    before do
      assign_role(user:, role: create_role('admin'))
    end

    let(:required_roles) { %w[admin hr] }
    let(:role_match) { :all }

    it 'raises MissingRoleError' do
      expect do
        check_role
      end.to raise_error(RailsIam::Authorization::Exceptions::MissingRoleError)
    end
  end

  context 'when role_match is invalid' do
    let(:required_roles) { ['admin'] }
    let(:role_match) { :unknown }

    it 'raises ArgumentError' do
      expect do
        check_role
      end.to raise_error(ArgumentError)
    end
  end
end
