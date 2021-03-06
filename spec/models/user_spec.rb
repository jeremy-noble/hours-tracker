require 'spec_helper'
describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:id) }
  it { should_not respond_to(:name) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:default_hourly_rate) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should_not allow_mass_assignment_of(:id) }
  it { should_not allow_mass_assignment_of(:admin) }
  
  it { should have_many(:time_sheets) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:default_hourly_rate) }
  it { should validate_numericality_of(:default_hourly_rate) }
  it { should have_db_column(:default_hourly_rate).
          of_type(:decimal).
          with_options(:precision => 8, :scale => 2) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when email address is already taken" do
    before(:each) do
      email = "jeremy@blah.com"
      @user = FactoryGirl.create(:user, email: email)
      @user_with_same_email = FactoryGirl.build(:user, email: email.upcase) #also test case sensitivity
    end
     it "should be invalid regardless of case" do
      @user_with_same_email.should_not be_valid
    end
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user = FactoryGirl.build(:user, email: invalid_address)
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user = FactoryGirl.build(:user, email: valid_address)
        @user.should be_valid
      end      
    end
  end

  describe "when user enters a capitalized email" do
    before(:each) do
      @user = FactoryGirl.create(:user, email: "JEREMY@ALLCAPS.COM")
    end
    it "should be save as downcase" do
      @user.email.should == "jeremy@allcaps.com"
    end
  end

  describe "when password is not present" do
    before(:each) do
      @user = FactoryGirl.build(:user, password: " ", password_confirmation: " " )
    end
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when password confirmation is nil" do
    before(:each) do
      @user = FactoryGirl.build(:user, password_confirmation: nil)
    end
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when password doesn't match confirmation" do
    before(:each) do
      @user = FactoryGirl.build(:user, password: 'blahblah', password_confirmation: 'mismatch' )
    end
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "with a password that's too short" do
    before(:each) do
      @user = FactoryGirl.build(:user, password: 'a' * 4, password_confirmation: 'a' * 4 )
    end
    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when updating a user" do
    before(:each) do
      user = FactoryGirl.create(:user)
      @saved_user = User.find(user)
    end
    it "should allow updates without specifiying a password" do
      @saved_user.update_attributes(default_hourly_rate: 3)
      @saved_user.should be_valid
    end
  end

  describe "return value of authenticate method" do
    describe "with valid password" do
      it { should == user.authenticate(user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      it { user_for_invalid_password.should be_false }
    end
  end

  describe "with admin attribute set to 'true'" do
    before do
      user.save!
      user.toggle!(:admin)
    end

    it { should be_admin }
  end

end