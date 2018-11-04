# spec/models/customer_spec.rb
require "rails_helper"

RSpec.describe Customer, :type => :model do

  before(:all) do
    @customer1 = create(:customer)
  end

  it "is valid with valid attributes" do
    expect(@customer1).to be_valid
  end

  it "has a unique identifier" do
    customer2 = build(:customer, identifier: @customer1.identifier)
    expect(customer2).to_not be_valid
  end

  it "is not valid without a password" do
    customer2 = build(:customer, identifier: "customer2", password: nil)
    expect(customer2).to_not be_valid
  end

  it "is not valid without a identifier" do
    customer2 = build(:customer, identifier: nil)
    expect(customer2).to_not be_valid
  end

  it "is not valid without an email" do
    customer2 = build(:customer, email: nil)
    expect(customer2).to_not be_valid
  end
end
