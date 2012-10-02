require 'spec_helper'
describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:default_hourly_rate) }

  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:id) }
  
  it { should have_many(:time_sheets) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).
                  is_at_least(3).
                  is_at_most(50) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:default_hourly_rate) }
  it { should validate_numericality_of(:default_hourly_rate) }
  it { should have_db_column(:default_hourly_rate).
          of_type(:decimal).
          with_options(:precision => 8, :scale => 2) }


  it { should be_valid }

end