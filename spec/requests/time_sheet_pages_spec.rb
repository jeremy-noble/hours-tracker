require 'spec_helper'

describe "TimeSheet pages" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:time_sheet_hourly) { FactoryGirl.create(:time_sheet_hourly, user: user, notes: 'blah blah these are my notes') }
  let!(:time_sheet_salary) { FactoryGirl.create(:time_sheet_salary, user: user) }
  let!(:paid_time_sheet) { FactoryGirl.create(:paid_time_sheet, user: user) }

  subject { page }

  describe "index" do
    describe "as normal user" do
      
      before do
        log_in user
        visit user_time_sheets_path(user)
      end

      it { should have_selector('title', text: "Time sheets for #{user.first_name} #{user.last_name}") }
      it { should have_button('Create New Time Sheet') }
      it "should be able to create new time sheet" do
        expect { click_button('Create New Time Sheet') }.to change(TimeSheet, :count).by(1)
      end
      it { should have_exact_link('Add Hours', href: user_time_sheet_entries_path(user, time_sheet_hourly)) }
      it { should have_exact_link('View Hours', href: user_time_sheet_entries_path(user, paid_time_sheet)) }
      it { should_not have_link('Edit Time Sheet') }
      it { should_not have_link('Delete Time Sheet') }

      # note these values come from factories
      # time_sheet_hourly
        it { should have_content('24.5') }
        it { should_not have_content('$3,675.00') }
      # time_sheet_salary
        it { should_not have_content('17.5') }
        it { should have_content('$2,085.00') }
    end

    describe "as admin user" do
      before do
        log_in admin
        visit user_time_sheets_path(user)
      end

      it { should have_button('Create New Time Sheet') }
      it { should have_exact_link('Add Hours', href: user_time_sheet_entries_path(user, time_sheet_hourly)) }
      it { should have_exact_link('View Hours', href: user_time_sheet_entries_path(user, paid_time_sheet)) }
      it { should have_link('Edit Time Sheet') }
      it { should have_link('Delete Time Sheet') }
      it "should be able to delete time sheet" do
        expect { click_link('Delete Time Sheet') }.to change(TimeSheet, :count).by(-1)
      end
    end
  end

  describe "show" do
    describe "as normal user on un-paid time sheet" do
      before do
        log_in user
        visit user_time_sheet_path(user, time_sheet_hourly)
      end

      it { should_not have_link('Edit') }
      it { should_not have_link('Delete') }
      it { should have_content('Paid') }
      it { should have_content('No') }
    end

    describe "as normal user on paid time sheet" do
      before do
        log_in user
        visit user_time_sheet_path(user, paid_time_sheet)
      end

      it { should_not have_link('Edit') }
      it { should_not have_link('Delete') }
      it { should have_content('Paid') }
      it { should have_content('Yes') }
      it { should have_content("#{Date.today}") }
    end

    describe "as admin user" do
      before do
        log_in admin
        visit user_time_sheet_path(user, time_sheet_hourly)
      end

      it { should have_content('First name') }
      it { should have_content("#{user.first_name}") }
      it { should have_content('Last name') }
      it { should have_content("#{user.last_name}") }
      it { should have_content('Total hours') }
      it { should have_content("#{time_sheet_hourly.total_hours}") }
      it { should have_content('Paid') }
      it { should have_content("#{yesno(time_sheet_hourly.paid)}") }
      it { should have_content('Notes') }
      it { should have_content("#{time_sheet_hourly.notes}") }
      it { should have_link('Edit') }
      it { should have_link('Delete') }
      it "should be able to delete time sheet" do
        expect { click_link('Delete') }.to change(TimeSheet, :count).by(-1)
      end

    end
  end

  describe "edit" do
    context "as admin user" do
      before do
        log_in admin
        visit edit_user_time_sheet_path(user, time_sheet_hourly)
      end

      it { should have_button('Update Time sheet') }
      it { should have_field('Paid') }
      it { should have_field('Notes') }

    end
  end

end
