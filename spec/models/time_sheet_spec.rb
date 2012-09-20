require 'spec_helper'
describe TimeSheet do
  let(:user) { User.create(name: "Jeremy Kay") }
  let(:time_sheet) { user.time_sheets.create } 

  subject { time_sheet }

  it { should respond_to(:paid) }
  it { should respond_to(:user_id) }

  describe "accessible attributes" do
    it "should allow acces to paid" do
      TimeSheet.new(paid: false)
    end
    it "should NOT allow access to user_id" do
      expect do
        TimeSheet.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  it { should belong_to(:user) }
  it { should have_many(:entries) }
  its(:user) { should == user }

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
    pending "should use factory girl to create some records with created_at in ASC order, then should check that they come back in DESC order"
  end

  describe "total_hours should add up all the hours for a time sheet's entries" do
    pending
  end

end