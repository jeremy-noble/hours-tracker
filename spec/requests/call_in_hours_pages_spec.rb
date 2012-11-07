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
        @user_custom_rates = FactoryGirl.create(:user, default_hourly_rate: 30)
        @time_sheet = FactoryGirl.create(:time_sheet, user_id: @user_custom_rates.id)     
        @entry_1 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 3, hourly_rate: 75)
        @entry_2 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 11) #should get default hourly_rate from user "30"
        @entry_3 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 3.5, hourly_rate: 60)

        @user_default_rates = FactoryGirl.create(:user, default_hourly_rate: 60)
        @time_sheet = FactoryGirl.create(:time_sheet, user_id: @user_default_rates.id)     
        @entry_4 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 10)
        @entry_5 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 11)
        @entry_6 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 3.5)

        log_in admin
        visit call_in_hours_path
      end

      it { should have_selector('title', text: 'Call In Hours') }
      it { should have_link('Mark All Paid') }
      it { should have_content('24.5') }
      it { should_not have_content('$1,470.00') }
      it { should have_content('$765.00') }
      it { should_not have_content('17.5') }

      it "should be awesome" do
        pending
      end
    end
  end

end
