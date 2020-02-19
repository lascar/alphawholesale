require 'rails_helper'

RSpec.describe BrokerOrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let(:date) {DateTime.new(2018,8,11,18,8,0)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}
  let!(:order2) {create(:order, customer: customer2, offer: offer1)}
  let!(:order_hash) {{ customer_id: customer1.id, offer_id: offer1.id, quantity: 3}}

  describe "POST #create" do

    # TEST as a logged broker
    # TEST when order is asked for creating without customer
    # TEST then the attributes are not changed
    # TEST and the edit template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        order_hash[:customer_id] = nil
        post :create, params: {broker_id: broker1.id, order: order_hash}
      end

      it "does not change the attributes and renders the edit template" do
        expect(assigns(:order).persisted?).to be(false)
        expect(response.redirect_url).to eq(
          "http://test.host/brokers/#{broker1.id.to_s}/orders/new?offer_id=#{offer1.id.to_s}")
      end
    end

  end
end
