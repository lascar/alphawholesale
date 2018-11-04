# spec/models/supplier_spec.rb
require "rails_helper"

RSpec.describe Supplier, :type => :model do

  before(:all) do
    @supplier1 = create(:supplier)
  end

  it "is valid with valid attributes" do
    expect(@supplier1).to be_valid
  end

  it "has a unique identifier" do
    supplier2 = build(:supplier, identifier: @supplier1.identifier)
    expect(supplier2).to_not be_valid
  end

  it "is not valid without a password" do
    supplier2 = build(:supplier, identifier: "supplier2", password: nil)
    expect(supplier2).to_not be_valid
  end

  it "is not valid without a identifier" do
    supplier2 = build(:supplier, identifier: nil)
    expect(supplier2).to_not be_valid
  end

  it "is not valid without an email" do
    supplier2 = build(:supplier, email: nil)
    expect(supplier2).to_not be_valid
  end
end
