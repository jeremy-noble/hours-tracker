require 'spec_helper'
describe Entry do
  let(:entry) { FactoryGirl.create(:entry) }

  subject { entry }

  it { should respond_to(:id) }
  it { should respond_to(:date) }
  it { should respond_to(:hours) }
  it { should respond_to(:project) }
  it { should respond_to(:hourly_rate) }

  it { should allow_mass_assignment_of(:date) }
  it { should allow_mass_assignment_of(:hours) }
  it { should allow_mass_assignment_of(:project) }
  it { should allow_mass_assignment_of(:hourly_rate) }
  it { should_not allow_mass_assignment_of(:time_sheet_id) }

  it { should belong_to(:time_sheet) }
  
  it { should validate_presence_of(:time_sheet_id) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:hours) }
  it { should validate_numericality_of(:hours) }
  it { should validate_numericality_of(:hourly_rate) }
  it { should have_db_column(:hours).
          of_type(:decimal).
          with_options(:precision => 4, :scale => 2) }
  it { should have_db_column(:hourly_rate).
          of_type(:decimal).
          with_options(:precision => 8, :scale => 2) }
  # test boundaries for :hours. should be greater than 0 and less than 24
    it { should_not allow_value(-0.01).for(:hours) }
    it { should_not allow_value(0).for(:hours) }
    it { should allow_value(0.01).for(:hours) }
    it { should allow_value(23.99).for(:hours) }
    it { should_not allow_value(24).for(:hours) }
    it { should_not allow_value(24.01).for(:hours) }  
  
  it { should be_valid }

  describe "should be ordered by date DESC" do
    before(:each) do
      @time_sheet = FactoryGirl.create(:time_sheet)
    end

    let!(:older_entry) do 
      FactoryGirl.create(:entry, time_sheet_id: @time_sheet.id, date: 1.year.ago, hours: 5)
    end
    let!(:newer_entry) do
      FactoryGirl.create(:entry, time_sheet_id: @time_sheet.id, date: 1.hour.ago, hours: 5)
    end

    it "should have the right entries in the right order" do     
     @time_sheet.entries.should == [newer_entry, older_entry]
    end
  end 

  describe "when created with NO hourly_rate" do
    before(:each) do
      @user = FactoryGirl.create(:user, default_hourly_rate: 30)
      @time_sheet = FactoryGirl.create(:time_sheet, user_id: @user.id)
      @entry = Entry.new(date: Date.today, hours: 5)
      @entry.time_sheet_id = @time_sheet.id
      @entry.hourly_rate = nil
      @entry.save
      # @entry = FactoryGirl.create(:entry, time_sheet_id: @time_sheet.id, hourly_rate: nil)
    end
    it "should have the user.default_hourly_rate" do
      # raise @entry.inspect
      @entry.hourly_rate.should == @user.default_hourly_rate
    end
  end

  describe "when created with hourly_rate" do
    it "should have the hourly rate that was set" do
      pending
    end
  end













end