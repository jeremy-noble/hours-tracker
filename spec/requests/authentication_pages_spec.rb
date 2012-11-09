require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Log In') }
    it { should have_selector('title', text: 'Log In') }
  end

  describe "login" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Log In" }

      it { should have_selector('title', text: 'Log In') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { visit root_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { log_in user }

      it { should have_link('Log Out', href: logout_path) }
      it { should_not have_link('Log In', href: login_path) }

      describe "followed by log out" do
        before { click_link "Log Out" }
        it { should have_link('Log In') }
      end
    end

  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:time_sheet) { FactoryGirl.create(:time_sheet, user: user) }
      let(:entry) { FactoryGirl.create(:entry, time_sheet: time_sheet) }

      describe "in the call_in_hours controller" do
        describe "visiting the index page" do
          before { visit call_in_hours_path }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "putting to the mark_paid page" do
          before { put mark_paid_path }
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Users controller" do
        # NOTE: these are just basic tests to make sure users get redirected to login
        # extensive testing for permissions is in spec/models/ability_spec
        # essentially this checks to make sure I included the load_and_authorize_resource in the controller

        describe "visiting the index page" do
          before { visit users_path }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "visiting the show page" do
          before { visit user_path(user) }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "visiting the new page" do
          before { visit new_user_path }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "posting to the create action" do
          before { post users_path }
          specify { response.should redirect_to(login_path) }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end

         describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(login_path) }        
        end
      end

      describe "in the time_sheets controller" do
         describe "visiting the index page" do
          before { visit user_time_sheets_path(user) }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "visiting the show page" do
          before { visit user_time_sheet_path(user, time_sheet) }
          it { should have_selector('title', text: 'Log In') }
        end
      end

      describe "in the entries controller" do
        describe "visiting the index page" do
          before { visit user_time_sheet_entries_path(user, time_sheet) }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "visiting the show page" do
          before { visit user_time_sheet_entry_path(user, time_sheet, entry) }
          it { should have_selector('title', text: 'Log In') }
        end
      end

    end

    describe "as valid non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      before { log_in user }

      it { should have_link('My Account') }
      it { should have_link('My Time Sheets') }
      it { should have_content("Hours Tracker - #{user.first_name} #{user.last_name}") }

      context "when there is an unpaid time sheet" do
        let!(:time_sheet) { FactoryGirl.create(:time_sheet, user: user) }
        before { log_in user }
        it { should have_selector('title', text: "Hours for Time Sheet ##{time_sheet.id}")}
      end

      context "when there are only paid time sheets" do
        let!(:user_with_paid_time_sheets) { FactoryGirl.create(:user) }
        let!(:paid_time_sheet) { FactoryGirl.create(:paid_time_sheet, user: user_with_paid_time_sheets) }
        it "should increase the TimeSheet count by 1" do
          expect { log_in user_with_paid_time_sheets }.to change(TimeSheet, :count).by(1)
        end
        
      end

      describe "click My Account" do
        before { click_link "My Account" }
        it { should have_selector('title', text: "#{user.first_name} #{user.last_name}") }
      end

      describe "click My Time Sheets" do
        before { click_link "My Time Sheets" }
        it { should have_selector('title', text: "Time sheets for #{user.first_name} #{user.last_name}") }
      end

      it { should_not have_link('All Users') }

      describe "should not allow access to user#index" do
        before { visit users_path }
        it { should have_selector('title', text: 'Log In') }
      end
    end

    describe "as admin user" do
      let(:admin_user) { FactoryGirl.create(:admin) }
      before { log_in admin_user }

      it { should have_selector('title', text: 'Call In Hours') }

      it { should have_link('Call In Hours') }
      it { should have_link('All Users') }

      describe "click All Users" do
        before { click_link "All Users" }
        it { should have_selector('title', text: "All Users") }
      end

      describe "should allow access to user#index" do
        before { visit users_path }
        it { should_not have_selector('title', text: 'Log In') }
      end

      describe "click Call In Hours" do
        before { click_link "Call In Hours" }
        it { should have_selector('title', text: "Call In Hours") }
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      let(:wrong_time_sheet) { FactoryGirl.create(:time_sheet, user: wrong_user) }
      before { log_in user }

      describe "visiting Users#show page" do
        before { visit user_path(wrong_user) }
        it { should_not have_selector('title', text: "#{wrong_user.first_name} #{wrong_user.last_name}") }
      end

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(login_path) }
      end

      describe "should not allow access to another user's time_sheets" do
        before { visit user_time_sheets_path(wrong_user) }
        it { should have_selector('title', text: 'Log In') }
      end

      describe "should not allow access to another user's time_sheet's entries" do
        before { visit user_time_sheet_entries_path(wrong_user, wrong_time_sheet) }
        it { should have_selector('title', text: 'Log In') }
      end

    end

  end

end