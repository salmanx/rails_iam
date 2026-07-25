require 'rails_helper'

RSpec.describe RailsIam::RefreshToken, type: :model do
  subject { create(:refresh_token) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end