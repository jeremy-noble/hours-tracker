require 'spec_helper'
describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:default_hourly_rate) }
  # it { should respond_to(:password_digest) }
  # it { should respond_to(:password) }
  # it { should respond_to(:password_confirmation) }
  # it { should respond_to(:authenticate) }

  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:id) }
  
  it { should have_many(:time_sheets) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).
                  is_at_least(3).
                  is_at_most(50) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:default_hourly_rate) }
  it { should validate_numericality_of(:default_hourly_rate) }
  it { should have_db_column(:default_hourly_rate).
          of_type(:decimal).
          with_options(:precision => 8, :scale => 2) }
  # it { should validate_presence_of(:password) }
  # it { should validate_presence_of(:password_confirmation) }

  it { should be_valid }

  describe "when email address is already taken" do
    before(:each) do
      email = "jeremy@blah.com"
      @user = FactoryGirl.create(:user, name: "foobar1", email: email)
      @user_with_same_email = FactoryGirl.build(:user, name: "foobar2", email: email.upcase) #also test case sensitivity
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
        @user = FactoryGirl.create(:user, email: invalid_address)
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user = FactoryGirl.create(:user, email: valid_address)
        @user.should be_valid
      end      
    end
  end

  # describe "when password doesn't match confirmation" do
  #   before(:each) do
  #     @user = FactoryGirl.create(:user, password: 'blah', password_confirmation: 'mismatch' )
  #   end
  #   it { should_not be_valid }
  # end

  # describe "when password confirmation is nil" do
  #   before(:each) do
  #     @user = FactoryGirl.create(:user, password_confirmation: nil )
  #   end
  #   it { should_not be_valid }
  # end


end