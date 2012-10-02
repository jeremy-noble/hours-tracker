require 'spec_helper'
describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:id) }
  it { should respond_to(:name) }

  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:id) }
  
  it { should have_many(:time_sheets) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).
                  is_at_least(3).
                  is_at_most(50) }
  it { should validate_uniqueness_of(:name) }


  it { should be_valid }

end