require 'spec_helper'
describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:time_sheets) }
  it { should have_many(:time_sheets) }

  it { should be_valid }

  describe "when name is not present" do
    before { user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { user.name = "a" * 2 }
    it { should be_invalid }
  end

end