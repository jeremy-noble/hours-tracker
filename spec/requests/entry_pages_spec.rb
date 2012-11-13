require 'spec_helper'

describe "Entry pages" do
  let!(:user) { FactoryGirl.create(:user, default_hourly_rate: 50) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:time_sheet) { FactoryGirl.create(:time_sheet, user: user) }
  let!(:paid_time_sheet) { FactoryGirl.create(:paid_time_sheet, user: user) }
  let!(:entry) { FactoryGirl.create(:entry, time_sheet: time_sheet, hours: 10) }
  let!(:entry_custom_rate) { FactoryGirl.create(:entry, time_sheet: time_sheet, hours: 5, hourly_rate: 75 ) }
  let!(:paid_entry) { FactoryGirl.create(:entry, time_sheet: paid_time_sheet) }

  subject { page }

  describe "index" do

    describe "as normal user" do
      before { log_in user }

      context "on a time sheet with no entries" do
        let(:empty_time_sheet) { FactoryGirl.create(:time_sheet, user: user) }
        before { visit user_time_sheet_entries_path(user, empty_time_sheet) }
        it { should have_link('Add New Hours') }
      end

      context "on normal time sheet" do
        before { visit user_time_sheet_entries_path(user, time_sheet) }

        it { should have_content("#{user.first_name} #{user.last_name}") }
        it { should have_link('Add New Hours') }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
        it { should_not have_exact_link('Edit Time Sheet') }

        it { should have_content('Totals') }
        it { should have_content('15.0') }
        it { should have_content('$500.00') } #subtotal for entry
        it { should have_content('$375.00') } #subtotal for entry_custom_rate
        it { should have_content('$875.00') } #total for all entries
      end

      context "on a paid time sheet" do
        before { visit user_time_sheet_entries_path(user, paid_time_sheet) }

        it { should_not have_link('Add New Hours') }
        it { should_not have_exact_link('Edit') }
        it { should_not have_link('Delete') }
        it { should have_content('Paid') }
        it { should have_content('Yes') }
        it { should have_content("#{Date.today}") }
      end
    end

    describe "as admin user" do
      before { log_in admin }

      context "on normal time sheet" do
        before { visit user_time_sheet_entries_path(user, time_sheet) }

        it { should have_content("#{user.first_name} #{user.last_name}") }
        it { should have_link('Add New Hours') }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
        it { should have_exact_link('Edit Time Sheet') }
      end

      context "on a paid time sheet" do
        before { visit user_time_sheet_entries_path(user, paid_time_sheet) }

        it { should have_link('Add New Hours') }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
      end
    end

  end

  describe "new" do

    describe "create new valid entry" do
      before do 
        log_in user
        visit new_user_time_sheet_entry_path(user, time_sheet)
        fill_in "Hours",    with: "5"
        click_button "Create Entry"
      end
      
      describe "should redirect to entries#index" do
        it { should have_content("Hours for Time Sheet ##{time_sheet.id}") }
      end
    end

  end

end
