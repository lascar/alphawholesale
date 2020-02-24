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

  describe "PUT #update" do

    # TEST as a logged broker
    # TEST when an order is asked for updating without supplier
    # TEST then the attributes are not changed
    # TEST and the edit template is rendered
    describe "as a logged broker" do
      before :each do
        @controller = BrokerOrdersController.new
        sign_in(broker1)
        order_hash[:customer_id] = nil
        put :update, params: {broker_id: broker1.id, id: order1.to_param, order: order_hash}
      end

      it "does not change the attributes" do
        expect(Order.find(order1.id).quantity).to eq(order1.quantity)
      end

      it "redirect to edit" do
        expect(response.redirect_url).to eq(
          "http://test.host/brokers/#{broker1.id.to_s}/orders/#{order1.id.to_s}/edit")
      end
    end

    # TEST as a logged broker
    # TEST when an order is asked for updating with supplier
    # TEST then the attributes are changed
    # TEST and it's redirected to the order
    describe "as a logged broker" do
      before :each do
        @controller = BrokerOrdersController.new
        sign_in(broker1)
        put :update, params: {broker_id: broker1.id, id: order1.id, order: order_hash}
      end

      it "assigns the updated order" do
        expect(assigns(:order).persisted?).to be(true)
      end

      it "updated the attributes" do
        expect(assigns(:order).quantity).to eq(order_hash[:quantity])
      end

      it "redirect to the newly updated order" do
        expect(response.redirect_url).to eq(
          "http://test.host/brokers/#{broker1.id.to_s}/orders/#{order1.id.to_s}")
      end
    end
  end
end
