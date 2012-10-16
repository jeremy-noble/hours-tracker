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


      it { should have_selector('title', text: "Time sheets for #{user.name}") }
      it { should have_link('Log Out', href: logout_path) }
      it { should_not have_link('Log In', href: login_path) }

      describe "followed by log out" do
        before { click_link "Log Out" }
        it { should have_link('Log In') }
      end
    end
  end

  describe "authorization" do

    # NOTE: SWITCHED AUTHORIZATION TO CANCAN
    # THESE TESTS SHOULD PASS, BUT MAIN AUTHORIZATION TESTS SHOULD BE IN /models/ability_spec 

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

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
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { log_in user }

      describe "visiting Users#show page" do
        before { visit user_path(wrong_user) }
        it { should_not have_selector('title', text: wrong_user.name) }
      end

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(login_path) }
      end
    end

  end

end