require 'spec_helper'
describe TimeSheet do
  let!(:normal_user) { FactoryGirl.create(:user) }
  let!(:admin_user) { FactoryGirl.create(:admin) }
  let(:time_sheet) { FactoryGirl.create(:time_sheet) }

  subject { time_sheet }

  it { should respond_to(:id) }
  it { should respond_to(:paid) }
  it { should respond_to(:user_id) }
  it { should respond_to(:notes) }

  it { should allow_mass_assignment_of(:paid) }
  it { should allow_mass_assignment_of(:notes) }
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should_not allow_mass_assignment_of(:user) }

  it { should belong_to(:user) }
  it { should have_many(:entries) }

  it { should validate_presence_of(:user_id) }
  
  it { should be_valid }


  describe "should be ordered by created_at desc" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    let!(:older_time_sheet) do 
      FactoryGirl.create(:time_sheet, user_id: @user.id, created_at: 1.day.ago)
    end
    let!(:newer_time_sheet) do
      FactoryGirl.create(:time_sheet, user_id: @user.id, created_at: 1.hour.ago)
    end

    it "should have the right time sheets in the right order" do
      @user.time_sheets.should == [newer_time_sheet, older_time_sheet]
    end
  end

  describe "when there are a few entries" do
    before(:each) do
      @user = FactoryGirl.create(:user, default_hourly_rate: 30)
      @time_sheet = FactoryGirl.create(:time_sheet, user_id: @user.id)     
      @entry_1 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 3, hourly_rate: 75)
      @entry_2 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 11) #should get default hourly_rate from user "30"
      @entry_3 = FactoryGirl.create(:entry, time_sheet: @time_sheet, hours: 3.5, hourly_rate: 60)
    end

    it "should return the correct total_hours" do
      @time_sheet.total_hours.should == 17.5
    end

    it "should return the correct total_cash for a time sheet's entries" do
      @time_sheet.total_cash.should == (75*3) + (11*30) + (60*3.5)
    end

    describe "when the default_hourly_rate for the user are changed" do
      it "should not change total_cash" do
        @user.default_hourly_rate = 60
        @user.save
        @time_sheet.total_hours.should == 17.5

        @user.default_hourly_rate = 40.5
        @user.save
        @time_sheet.total_hours.should == 17.5
      end 
    end 
  end

  describe "when there are time_sheets with custom hourly rates, and only default hourly rates" do
    before(:each) do
      @user = FactoryGirl.create(:user, default_hourly_rate: 30)
      @time_sheet_custom_rates = FactoryGirl.create(:time_sheet, user_id: @user.id)     
      @entry_1 = FactoryGirl.create(:entry, time_sheet: @time_sheet_custom_rates, hours: 3, hourly_rate: 75)
      @entry_2 = FactoryGirl.create(:entry, time_sheet: @time_sheet_custom_rates, hours: 11) #should get default hourly_rate from user "30"
      @entry_3 = FactoryGirl.create(:entry, time_sheet: @time_sheet_custom_rates, hours: 3.5, hourly_rate: 60)

      @time_sheet_default_rates = FactoryGirl.create(:time_sheet, user_id: @user.id)     
      @entry_4 = FactoryGirl.create(:entry, time_sheet: @time_sheet_default_rates, hours: 3)
      @entry_5 = FactoryGirl.create(:entry, time_sheet: @time_sheet_default_rates, hours: 11)
      @entry_6 = FactoryGirl.create(:entry, time_sheet: @time_sheet_default_rates, hours: 3.5)
    end

    it "time_sheet_default_rates should be hourly only" do
      @time_sheet_default_rates.hourly_only?.should == true
    end

    it "time_sheet_custom_rates should be hourly only" do
      @time_sheet_custom_rates.hourly_only?.should == false
    end
  end

end