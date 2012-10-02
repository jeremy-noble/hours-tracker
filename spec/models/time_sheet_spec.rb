require 'spec_helper'
describe TimeSheet do
  let(:time_sheet) { FactoryGirl.create(:time_sheet) }

  subject { time_sheet }

  it { should respond_to(:id) }
  it { should respond_to(:paid) }
  it { should respond_to(:user_id) }

  it { should allow_mass_assignment_of(:paid) }
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

  it "should return the correct total_hours a time sheet's entries" do
    # is there a better way to do this?
    entry_1 = FactoryGirl.create(:entry, time_sheet: time_sheet, hours: 3)
    entry_2 = FactoryGirl.create(:entry, time_sheet: time_sheet, hours: 11)
    entry_3 = FactoryGirl.create(:entry, time_sheet: time_sheet, hours: 3.32)

    time_sheet.total_hours.should == (entry_1.hours + entry_2.hours + entry_3.hours).to_s
  end

end