require 'spec_helper'
describe TimeSheet do
  let(:time_sheet) { FactoryGirl.create(:time_sheet) }

  subject { time_sheet }

  it { should respond_to(:id) }
  it { should respond_to(:paid) }
  it { should respond_to(:user_id) }

  it { should allow_mass_assignment_of(:paid) }
  it { should_not allow_mass_assignment_of(:user_id) }

  it { should belong_to(:user) }
  it { should have_many(:entries) }

  it { should validate_presence_of(:user_id) }
  
  it { should be_valid }


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
    pending
    # 100.times { FactoryGirl.create(:time_sheet) }

  end

end