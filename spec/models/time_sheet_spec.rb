require 'spec_helper'
describe TimeSheet do
  let(:time_sheet) { FactoryGirl.create(:time_sheet) }

  subject { time_sheet }

  it { should respond_to(:paid) }
  it { should respond_to(:user_id) }

  describe "accessible attributes" do
    it "should allow acces to paid" do
      TimeSheet.new(paid: false)
    end
    it "should NOT allow access to user_id" do
      expect do
        TimeSheet.new(user_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  it { should belong_to(:user) }
  it { should have_many(:entries) }

  it { should be_valid }

  describe "when user_id is not present" do
    before { time_sheet.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "by default paid should be false and not nil" do
    it { time_sheet.paid.should be_false }
    it { time_sheet.paid.should_not be_nil }
  end

  describe "should be ordered by created_at desc" do
    user_temp =  FactoryGirl.create(:user)

    let!(:older_time_sheet) do 
      FactoryGirl.create(:time_sheet, user_id: user_temp.id, created_at: 1.day.ago)
    end
    let!(:newer_time_sheet) do
      FactoryGirl.create(:time_sheet, user_id: user_temp.id, created_at: 1.hour.ago)
    end

    it "should have the right time sheets in the right order" do
      user_temp.time_sheets.should == [newer_time_sheet, older_time_sheet]
    end
  end

  describe "total_hours should add up all the hours for a time sheet's entries" do
    100.times { FactoryGirl.create(:time_sheet) }

  end

end