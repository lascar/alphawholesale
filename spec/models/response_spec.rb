require 'rails_helper'

RSpec.describe Response, :type => :model do

  before(:all) do
    @response1 = create(:response)
  end

  it "is valid with valid attributes" do
    expect(@response1).to be_valid
  end

  it "is not valid without supplier" do
    response2 = build(:response, supplier_id: nil)
    expect(response2).to_not be_valid
  end

  it 'does not queue the job "WarnInterestedJob" if update and not approved' do
    @response1.update(quantity: 2)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(false) 
  end

  it 'does queue the job "SendSupplierResponseApprovalJob" on approved' do
    @response1.update(approved: true)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == SendSupplierResponseApprovalJob}).to be(true) 
  end

  it 'queues the job "WarnInterestedJob" if update and approved' do
    @response1.update(quantity: 2)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.any? {|queue| queue[:job] == WarnInterestedJob}).to be(true) 
  end
end
