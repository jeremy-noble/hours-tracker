require 'spec_helper'

describe "Entry pages" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:time_sheet) { FactoryGirl.create(:time_sheet, user: user) }
  let!(:paid_time_sheet) { FactoryGirl.create(:time_sheet, paid: true, user: user) }
  let!(:entry) { FactoryGirl.create(:entry, time_sheet: time_sheet) }
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

        it { should have_link('Add New Hours') }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
      end

      context "on a paid time sheet" do
        before { visit user_time_sheet_entries_path(user, paid_time_sheet) }

        it { should_not have_link('Add New Hours') }
        it { should_not have_link('Edit') }
        it { should_not have_link('Delete') }
      end
    end

    describe "as admin user" do
      before { log_in admin }

      context "on normal time sheet" do
        before { visit user_time_sheet_entries_path(user, time_sheet) }

        it { should have_link('Add New Hours') }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
      end

      context "on a paid time sheet" do
        before { visit user_time_sheet_entries_path(user, paid_time_sheet) }

        it { should have_link('Add New Hours') }
        it { should have_link('Edit') }
        it { should have_link('Delete') }
      end
    end

  end
end
