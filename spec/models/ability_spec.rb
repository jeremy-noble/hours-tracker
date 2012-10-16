require 'spec_helper'
describe 'User' do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

    context 'when is guest' do
      let(:user){ FactoryGirl.create(:user) }

      it{ should_not be_able_to(:read, User.new) }
      it{ should_not be_able_to(:manage, User.new) }
    end
  end
end