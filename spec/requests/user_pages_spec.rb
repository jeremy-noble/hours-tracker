require 'spec_helper'

describe "User pages" do
  let!(:non_admin_user) { FactoryGirl.create(:user) }
  let!(:admin_user) { FactoryGirl.create(:user, admin: true) }

  subject { page }

  describe "index" do

    describe "as non-admin user" do
      
      before do
        log_in non_admin_user
        visit users_path
      end

      it { should have_selector('title', text: 'Log In') }
      it { should_not have_link('Delete User') }
      it { should_not have_link('Edit User') }
      it { should_not have_link('New User') }
    end

    describe "as admin user" do

      before do
        log_in admin_user
        visit users_path
      end

      it { should have_selector('title', text: 'All Users') }
      it { should have_link("#{non_admin_user.name}", href: user_path(non_admin_user)) }
      it { should have_link('New User', href: new_user_path) }
      it { should have_link('Edit User', href: edit_user_path(non_admin_user)) }
      it { should have_link('Delete User', href: user_path(non_admin_user)) }
      it "should be able to delete another user" do
        expect { click_link('Delete User') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('Delete User', href: user_path(admin_user)) }

    end

  end

  describe "show" do

    describe "as non-admin user" do
      
      before do
        log_in non_admin_user
        visit user_path(non_admin_user)
      end

      it { should have_selector('title', text: "#{non_admin_user.name}") }
      it { should have_exact_link('Time Sheets', href: user_time_sheets_path(non_admin_user)) }
      it { should_not have_link('Delete User') }
      it { should_not have_link('Edit User') }
    end

    describe "as admin user" do

      before do
        log_in admin_user
        visit user_path(non_admin_user)
      end

      it { should have_selector('title', text: "#{non_admin_user.name}") }
      it { should have_exact_link('Time Sheets', href: user_time_sheets_path(non_admin_user)) }
      it { should have_link('Edit User', href: edit_user_path(non_admin_user)) }
      it { should have_link('Delete User', href: user_path(non_admin_user)) }
      it "should be able to delete another user" do
        expect { click_link('Delete User') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('Delete User', href: user_path(admin_user)) }

    end

  end



end
