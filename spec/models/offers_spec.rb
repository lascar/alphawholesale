# spec/models/offer_spec.rb
require "rails_helper"

RSpec.describe Offer, :type => :model do

  before(:all) do
    @offer1 = create(:offer)
  end

  it "is valid with valid attributes" do
    expect(@offer1).to be_valid
  end

  it "is not valid without a concrete product" do
    offer2 = build(:offer, concrete_product_id: nil)
    expect(offer2).to_not be_valid
  end

  it "is not valid without supplier" do
    offer2 = build(:offer, supplier_id: nil)
    expect(offer2).to_not be_valid
  end

  it 'does not queue the job "WarnInterestedJob" if update and not approved' do
    @offer1.update(incoterm: 'EXW')
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(false) 
  end

  it 'does queue the job "SendSupplierOfferApprovalJob" on approved' do
    @offer1.update(approved: true)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == SendSupplierOfferApprovalJob}).to be(true) 
  end

  it 'queues the job "WarnInterestedJob" if update and approved' do
    @offer1.update(incoterm: 'EXW')
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(true) 
  end

end
