require 'spec_helper'

describe "CallInHours pages" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:time_sheet) { FactoryGirl.create(:time_sheet, user: user, notes: 'blah blah these are my notes') }
  let!(:paid_time_sheet) { FactoryGirl.create(:time_sheet, paid: true, user: user) }

  subject { page }

  describe "index" do
    context "as non-admin user" do
      before do
        log_in user
        visit call_in_hours_path
      end

      it { should have_selector('title', text: 'Log In') }
    end

    context "as admin user" do
      before(:each) do
        @user_1 = FactoryGirl.create(:user, default_hourly_rate: 30)
        @time_sheet_1 = FactoryGirl.create(:time_sheet, user_id: @user_1.id)     
        @entry_1 = FactoryGirl.create(:entry, time_sheet: @time_sheet_1, hours: 3, hourly_rate: 75)
        @entry_2 = FactoryGirl.create(:entry, time_sheet: @time_sheet_1, hours: 11) #should get default hourly_rate from user "30"
        @entry_3 = FactoryGirl.create(:entry, time_sheet: @time_sheet_1, hours: 3.5, hourly_rate: 60)

        @user_2 = FactoryGirl.create(:user, default_hourly_rate: 60)
        @time_sheet_2 = FactoryGirl.create(:time_sheet, user_id: @user_2.id)     
        @entry_4 = FactoryGirl.create(:entry, time_sheet: @time_sheet_2, hours: 10)
        @entry_5 = FactoryGirl.create(:entry, time_sheet: @time_sheet_2, hours: 11)
        @entry_6 = FactoryGirl.create(:entry, time_sheet: @time_sheet_2, hours: 3.5)

        log_in admin
        visit call_in_hours_path
      end

      it { should have_selector('title', text: 'Call In Hours') }
      it { should have_button('Mark All Paid') }
      it { should have_content('24.5') }
      it { should_not have_content('$1,470.00') }
      it { should have_content('$765.00') }
      it { should_not have_content('17.5') }

      context "when Mark All Paid button is pressed" do
        before { click_button 'Mark All Paid' }
        it "should mark all the time sheet paid" do
          # lookup saved records
          saved_time_sheet_1 = TimeSheet.find(@time_sheet_1)
          saved_time_sheet_2 = TimeSheet.find(@time_sheet_2)

          # saved records should be paid
          saved_time_sheet_1.paid.should == true
          saved_time_sheet_2.paid.should == true
        end
        it { should have_content 'There are currently no unpaid time sheets.' }
      end

    end
  end

end
