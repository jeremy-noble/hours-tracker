require 'spec_helper'

describe "CallInHours pages" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:time_sheet_hourly) { FactoryGirl.create(:time_sheet_hourly, user: user, notes: 'blah blah these are my notes') }
  let!(:time_sheet_salary) { FactoryGirl.create(:time_sheet_salary, user: user) }
  let!(:time_sheet_hourly_2) { FactoryGirl.create(:time_sheet_hourly, user: user) }
  let!(:time_sheet_salary_2) { FactoryGirl.create(:time_sheet_salary, user: user) }
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
      before do
        log_in admin
        visit call_in_hours_path
      end

      it { should have_selector('title', text: 'Call In Hours') }
      it { should have_content('Hours') }
      it { should have_content('Salary') }
      it { should have_content('Hourly Rate') }
      it { should have_content('$150.00') } #this is factory default
      it { should have_button('Mark All Paid') }

      # time_sheet_hourly
      it { should have_content('24.5') }
      it { should_not have_content('$3,675.00') }

      # time_sheet_salary
      it { should_not have_content('17.5') }
      it { should have_content('$2,085.00') }

      it { should have_content('49.0') }
      it { should have_content('$4,170.00') }

      context "when Mark All Paid button is pressed" do
        before { click_button 'Mark All Paid' }
        it "should mark all the time sheet paid" do
          # lookup saved records
          saved_time_sheet_1 = TimeSheet.find(time_sheet_hourly)
          saved_time_sheet_2 = TimeSheet.find(time_sheet_salary)

          # saved records should be paid
          saved_time_sheet_1.paid.should == true
          saved_time_sheet_2.paid.should == true
        end
        it { should have_content 'There are currently no unpaid time sheets.' }
      end

    end
  end

end
