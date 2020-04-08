# spec/models/order_spec.rb
require "rails_helper"

RSpec.describe Order, :type => :model do

  before(:all) do
    @order1 = create(:order)
  end

  it "is valid with valid attributes" do
    expect(@order1).to be_valid
  end

  it "is not valid without an offer" do
    order2 = build(:order, offer_id: nil)
    expect(order2).to_not be_valid
  end

  it "is not valid without customer" do
    order2 = build(:order, customer_id: nil)
    expect(order2).to_not be_valid
  end

  it "adquiers at create the concrete product of his offer" do
    concrete_product_id_offer = @order1.offer.concrete_product_id
    expect(@order1.concrete_product_id).to eq (concrete_product_id_offer)
  end 

  it 'does not queue the job "WarnInterestedJob" if update and not approved' do
    @order1.update(quantity: 1)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(false) 
  end

  it 'does queue the job "SendCustomerOrderApprovalJob" on approved' do
    @order1.update(approved: true)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == SendCustomerOrderApprovalJob}).to be(true) 
  end

  it 'queues the job "WarnInterestedJob" if update and approved' do
    @order1.update(quantity: 2)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(true) 
  end

end
