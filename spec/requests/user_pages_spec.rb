require 'spec_helper'

describe "User pages" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:admin) }

  subject { page }

  describe "index" do

    describe "as normal user" do
      
      before do
        log_in user
        visit users_path
      end

      it { should have_selector('title', text: 'Log In') }
      it { should_not have_link('Delete User') }
      it { should_not have_link('Edit User') }
      it { should_not have_link('New User') }
    end

    describe "as admin user" do

      before do
        log_in admin
        visit users_path
      end

      it { should have_selector('title', text: 'All Users') }
      it { should have_link("#{user.name}", href: user_path(user)) }
      it { should have_link('New User', href: new_user_path) }
      it { should have_link('Edit User', href: edit_user_path(user)) }
      it { should have_link('Delete User', href: user_path(user)) }
      it "should be able to delete another user" do
        expect { click_link('Delete User') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('Delete User', href: user_path(admin)) }

    end

  end

  describe "show" do

    describe "as nonrmal user" do
      
      before do
        log_in user
        visit user_path(user)
      end

      it { should have_selector('title', text: "#{user.name}") }
      it { should have_exact_link('Time Sheets', href: user_time_sheets_path(user)) }
      it { should_not have_link('Delete User') }
      it { should_not have_link('Edit User') }
    end

    describe "as admin user" do

      before do
        log_in admin
        visit user_path(user)
      end

      it { should have_selector('title', text: "#{user.name}") }
      it { should have_exact_link('Time Sheets', href: user_time_sheets_path(user)) }
      it { should have_link('Edit User', href: edit_user_path(user)) }
      it { should have_link('Delete User', href: user_path(user)) }
      it "should be able to delete another user" do
        expect { click_link('Delete User') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('Delete User', href: user_path(admin)) }

    end

  end



end
