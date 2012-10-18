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

      describe "with it's own user pages" do
        it{ should be_able_to(:read, current_user) }
        it{ should_not be_able_to(:create, current_user) }
        it{ should_not be_able_to(:update, current_user) }
        it{ should_not be_able_to(:destroy, current_user) }
      end

      describe "with other user's pages" do
        it{ should_not be_able_to(:read, wrong_user) }
        it{ should_not be_able_to(:create, wrong_user) }
        it{ should_not be_able_to(:update, wrong_user) }
        it{ should_not be_able_to(:destroy, wrong_user) }
      end

      describe "with it's own time sheets" do
        it{ should be_able_to(:read, FactoryGirl.create(:time_sheet, user: current_user)) }
        it{ should be_able_to(:create, FactoryGirl.create(:time_sheet, user: current_user)) }
        it{ should_not be_able_to(:update, FactoryGirl.create(:time_sheet, user: current_user)) }
        it{ should_not be_able_to(:destroy, FactoryGirl.create(:time_sheet, user: current_user)) }
      end

      describe "with other user's time sheets" do
        it{ should_not be_able_to(:read, FactoryGirl.create(:time_sheet, user: wrong_user)) }
        it{ should_not be_able_to(:create, FactoryGirl.create(:time_sheet, user: wrong_user)) }
        it{ should_not be_able_to(:update, FactoryGirl.create(:time_sheet, user: wrong_user)) }
        it{ should_not be_able_to(:destroy, FactoryGirl.create(:time_sheet, user: wrong_user)) }
      end
      
      describe "with it's own entries" do
        let(:time_sheet){ FactoryGirl.create(:time_sheet, user: current_user) }
        let(:paid_time_sheet){ FactoryGirl.create(:time_sheet, paid: true, user: current_user) }
        context "when the time_sheet is not yet paid" do
          it{ should be_able_to(:manage, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
        end
        context "when the time_sheet is paid" do
          it{ should be_able_to(:read, FactoryGirl.create(:entry, time_sheet: paid_time_sheet)) }
          it{ should_not be_able_to(:create, FactoryGirl.create(:entry, time_sheet: paid_time_sheet)) }
          it{ should_not be_able_to(:update, FactoryGirl.create(:entry, time_sheet: paid_time_sheet)) }
          it{ should_not be_able_to(:destroy, FactoryGirl.create(:entry, time_sheet: paid_time_sheet)) }
        end
      end

      describe "with other user's entries" do
        let(:time_sheet){ FactoryGirl.create(:time_sheet, user: wrong_user) }
        it{ should_not be_able_to(:read, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
        it{ should_not be_able_to(:create, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
        it{ should_not be_able_to(:update, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
        it{ should_not be_able_to(:destroy, FactoryGirl.create(:entry, time_sheet: time_sheet)) }
      end
      
    end

    context 'when is a logged Admin user' do
      let(:current_user){ FactoryGirl.create(:admin) } 
      
      it{ should be_able_to(:manage, :all) }
    end

  end
end