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
      it { should have_link("#{user.first_name} #{user.last_name}", href: user_path(user)) }
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

    describe "as normal user" do
      
      before do
        log_in user
        visit user_path(user)
      end

      it { should have_selector('title', text: "#{user.first_name} #{user.last_name}") }
      it { should have_exact_link('Time Sheets', href: user_time_sheets_path(user)) }
      it { should_not have_link('Delete User') }
      it { should_not have_link('Edit User') }
    end

    describe "as admin user" do

      before do
        log_in admin
        visit user_path(user)
      end

      it { should have_selector('title', text: "#{user.first_name} #{user.last_name}") }
      it { should have_exact_link('Time Sheets', href: user_time_sheets_path(user)) }
      it { should have_link('Edit User', href: edit_user_path(user)) }
      it { should have_link('Delete User', href: user_path(user)) }
      it "should be able to delete another user" do
        expect { click_link('Delete User') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('Delete User', href: user_path(admin)) }

    end

  end

  describe "new" do

    describe "as normal user" do
      
      before do
        log_in user
        visit new_user_path
      end

      it { should have_selector('title', text: 'Log In') }
      it { should_not have_button('Create User') }
    end

    describe "as admin user" do

      before do
        log_in admin
        visit new_user_path
      end

      it { should have_content('New User') }
      it { should have_field('First name') }
      it { should have_field('Last name') }
      it { should have_field('Password') }
      it { should have_field('Password confirmation') }
      it { should have_field('Default hourly rate') }
      it { should have_button('Create User') }
    end

  end



end
