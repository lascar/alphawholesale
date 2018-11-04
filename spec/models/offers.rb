# spec/models/offer_spec.rb
require "rails_helper"

RSpec.describe Offer, :type => :model do

  before(:all) do
    @offer1 = create(:offer)
  end

  it "is valid with valid attributes" do
    expect(@offer1).to be_valid
  end

  it "is not valid without product" do
    offer2 = build(:offer, product: nil)
    expect(offer2).to_not be_valid
  end

  it "is not valid without supplier" do
    offer2 = build(:offer, supplier: nil)
    expect(offer2).to_not be_valid
  end
end
