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
      it{ should be_able_to(:read, FactoryGirl.create(:time_sheet, user: current_user)) }
      it{ should_not be_able_to(:read, FactoryGirl.create(:time_sheet, user: wrong_user)) }
      it "should be able to create it's own time sheets" do
        should be_able_to(:create, FactoryGirl.create(:time_sheet, user: current_user))
      end
      it "should not be able to create other user's time sheets" do
        should_not be_able_to(:create, FactoryGirl.create(:time_sheet, user: wrong_user))
      end
      describe "should be able to read it's own entries" do
        let(:time_sheet){ FactoryGirl.create(:time_sheet, user: current_user) }
        it{ should be_able_to(:read, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
      end
      describe "should not be able to read other user's entries" do
        let(:time_sheet){ FactoryGirl.create(:time_sheet, user: wrong_user) }
        it{ should_not be_able_to(:read, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
      end
      describe "should be able to create it's own entries" do
        let(:time_sheet){ FactoryGirl.create(:time_sheet, user: current_user) }
        it{ should be_able_to(:create, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
      end
      describe "should not be able to create other user's entries" do
        let(:time_sheet){ FactoryGirl.create(:time_sheet, user: wrong_user) }
        it{ should_not be_able_to(:create, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
      end
    end

    context 'when is a logged Admin user' do
      let(:current_user){ FactoryGirl.create(:admin) } 

      it{ should be_able_to(:manage, :all) }
    end

  end
end