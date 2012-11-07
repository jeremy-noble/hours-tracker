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
      before do
        log_in admin
        visit call_in_hours_path
      end

      it { should have_selector('title', text: 'Call In Hours') }

      it "should be awesome" do
        pending
      end
    end
  end

end
