# spec/models/request_spec.rb
require "rails_helper"

RSpec.describe Request, :type => :model do

  before(:all) do
    @request1 = create(:request)
  end

  it "is valid with valid attributes" do
    expect(@request1).to be_valid
  end

  it "is not valid without a concrete product" do
    request2 = build(:request, concrete_product_id: nil)
    expect(request2).to_not be_valid
  end

  it "is not valid without customer" do
    request2 = build(:request, customer_id: nil)
    expect(request2).to_not be_valid
  end

  it 'does not queue the job "WarnInterestedJob" if update and not approved' do
    @request1.update(quantity: 2)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(false) 
  end

  it 'does queue the job "SendSupplierRequestApprovalJob" on approved' do
    @request1.update(approved: true)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == SendCustomerRequestApprovalJob}).to be(true) 
  end

  it 'queues the job "WarnInterestedJob" if update and approved' do
    @request1.update(quantity: 2)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(true) 
  end
end
