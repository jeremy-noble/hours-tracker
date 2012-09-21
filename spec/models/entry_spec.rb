require 'spec_helper'
describe Entry do
  let(:entry) { FactoryGirl.create(:entry) }

  subject { entry }

  it { should respond_to(:id) }
  it { should respond_to(:date) }
  it { should respond_to(:hours) }
  it { should respond_to(:project) }

  it { should allow_mass_assignment_of(:date) }
  it { should allow_mass_assignment_of(:hours) }
  it { should allow_mass_assignment_of(:project) }
  it { should_not allow_mass_assignment_of(:time_sheet_id) }

  it { should belong_to(:time_sheet) }
  
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:hours) }
  it { should validate_numericality_of(:hours) }
  it { should have_db_column(:hours).
          of_type(:decimal).
          with_options(:precision => 4, :scale => 2) }

  # is there a better way to test this range?
    it { should_not allow_value(-0.01).for(:hours) }
    it { should_not allow_value(0).for(:hours) }
    it { should_not allow_value(24).for(:hours) }
    # minimum = BigDecimal.new('0')
    # maximum = BigDecimal.new('24')
    # it { should ensure_inclusion_of(:hours).in_range(minimum...maximum).with_low_message("blah").with_high_message("hours must be less than 24 (#{BigDecimal.new('24')})") }

  it { should validate_presence_of(:time_sheet_id) }
  

  it { should be_valid }

  describe "should be ordered by date DESC" do
    time_sheet_temp =  FactoryGirl.create(:time_sheet)

    let!(:older_entry) do 
      FactoryGirl.create(:entry, time_sheet_id: time_sheet_temp.id, date: 1.year.ago)
    end
    let!(:newer_entry) do
      FactoryGirl.create(:entry, time_sheet_id: time_sheet_temp.id, date: 1.hour.ago)
    end

    it "should have the right time sheets in the right order" do
      time_sheet_temp.entries.should == [newer_entry, older_entry]
    end
  end  

end