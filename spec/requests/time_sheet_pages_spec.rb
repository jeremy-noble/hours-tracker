require 'spec_helper'

describe "TimeSheet pages" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:time_sheet) { FactoryGirl.create(:time_sheet, user: user) }

  subject { page }

  describe "index" do

    describe "as normal user" do
      
      before do
        log_in user
        visit user_time_sheets_path(user)
      end

      it { should have_selector('title', text: "Time sheets for #{user.name}") }
      it { should have_link('Create New Time Sheet') }
      it { should have_link('View/Add Hours') }
      it { should_not have_link('Mark Paid') }
      it { should_not have_link('Delete Time Sheet') }
    end

    describe "as admin user" do

      before do
        log_in admin
        visit user_time_sheets_path(user)
      end

      it { should have_link('Create New Time Sheet') }
      it { should have_link('View/Add Hours') }
      it { should have_link('Mark Paid') }
      it { should have_link('Delete Time Sheet') }
      it "should be able to delete time sheet" do
        expect { click_link('Delete Time Sheet') }.to change(TimeSheet, :count).by(-1)
      end

    end

  end
end
