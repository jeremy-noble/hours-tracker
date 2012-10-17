require 'spec_helper'
describe 'User' do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(user) }

    context 'when is not logged in' do
      let(:user){ nil }
      # let(:user){ FactoryGirl.create(:user) }

      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:read, :all) }
    end

    context 'when is a logged in normal user' do
      let(:user){ FactoryGirl.create(:user) } 
      let(:wrong_user){ FactoryGirl.create(:user, email: "wronguser@wrongywrong.com") }   

      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:read, :all) }
      it{ should be_able_to(:read, user) }
      it{ should_not be_able_to(:read, wrong_user) }
    end

  end
end