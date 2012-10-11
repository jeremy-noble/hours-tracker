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
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Log In"
      end

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

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Log In') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end
      end
    end
  end

end