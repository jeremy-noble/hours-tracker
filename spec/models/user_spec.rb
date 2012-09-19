require 'spec_helper'
describe User do
  before { @user = User.new(name: "Jeremy Kay") }

  subject { @user }

  it { should respond_to(:name) }
end