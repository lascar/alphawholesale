# spec/models/broker_spec.rb
require "rails_helper"

RSpec.describe Broker, :type => :model do

  before(:all) do
    @broker1 = create(:broker)
  end

  it "is valid with valid attributes" do
    expect(@broker1).to be_valid
  end

  it "has a unique identifier" do
    broker2 = build(:broker, identifier: @broker1.identifier)
    expect(broker2).to_not be_valid
  end

  it "is not valid without a password" do
    broker2 = build(:broker, identifier: "broker2", password: nil)
    expect(broker2).to_not be_valid
  end

  it "is not valid without a identifier" do
    broker2 = build(:broker, identifier: nil)
    expect(broker2).to_not be_valid
  end

  it "is not valid without an email" do
    broker2 = build(:broker, email: nil)
    expect(broker2).to_not be_valid
  end
end
