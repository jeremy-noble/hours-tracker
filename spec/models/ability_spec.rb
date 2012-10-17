require 'spec_helper'
describe 'User' do
  describe 'abilities' do
    subject { ability }
    let(:ability){ Ability.new(current_user) }

    context 'when is not logged in' do
      let(:current_user){ nil }

      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:read, :all) }
    end

    context 'when is a logged in normal user' do
      let(:current_user){ FactoryGirl.create(:user) } 
      let(:wrong_user){ FactoryGirl.create(:user, email: "wronguser@wrongywrong.com") }   

      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:read, :all) }
      it{ should be_able_to(:read, current_user) }
      it{ should_not be_able_to(:read, wrong_user) }
    end

  end
end