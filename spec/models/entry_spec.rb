require 'spec_helper'
describe Entry do
  let(:entry) { FactoryGirl.create(:entry) }

  subject { entry }

  it { should respond_to(:date) }
  it { should respond_to(:hours) }
  it { should respond_to(:project) }
  it { should belong_to(:time_sheet) }

  it { should be_valid }

  describe "when date is not present" do
    before { entry.date = " " }
    it { should_not be_valid }
  end

  describe "when hours is not present" do
    before { entry.hours = " " }
    it { should_not be_valid }
  end

  describe "when hours is not numeric" do
    before { entry.hours =  "kung fu" }
    it { should_not be_valid }
  end

  describe "when time_sheet_id is not present" do
    before { entry.time_sheet_id = nil }
    it { should_not be_valid }
  end

  describe "should be ordered by created_at desc" do
    pending "should use factory girl to create some records with created_at in ASC order, then should check that they come back in DESC order"
  end  

  describe "accessible attributes" do
    it "should not allow access to time_sheet_id" do
      expect do
        Entry.new(time_sheet_id: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

end