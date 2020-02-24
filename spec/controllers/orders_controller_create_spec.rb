require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
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
    # TEST as a guest user
    # TEST when order is asked for creating
    # TEST then it is routed to routing error
    it "does not routes post /orders to orders#create" do
      expect(:post => "/orders/").to route_to(controller: 'welcome',
                                                 action: 'routing_error',
                                                   url: 'orders')
    end

    # TEST as a logged supplier
    # TEST when order is asked for creating
    # TEST then it is routed to routing error
    it "does not routes post /suppliers/1/orders to orders#create" do
      sign_in(supplier1)
      expect(:put => "/suppliers/#{supplier1.id.to_s}/orders").to route_to(
        controller: 'welcome', action: 'routing_error',
        url: "suppliers/#{supplier1.id.to_s}/orders")
    end


    # TEST as a logged customer
    # TEST when order is asked for creating with approved
    # TEST then a new order is assigned
    # TEST and the order's attributes are initialized correctly
    # TEST and it's redirected to the order
    # TEST and the newly created order is not approved
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        order_hash[:customer_id] = customer1.id
        post :create, params: {customer_id: customer1.id, order: order_hash}
      end

      it "assigns the updated order and updated the attributes and
          redirect to the updated order and
          creates the new order but not as approved" do
        expect(assigns(:order).persisted?).to be(true)
        expect(assigns(:order).quantity).to eq(order_hash[:quantity])
        expect(response.redirect_url).to eq(
          "http://test.host/customers/" + customer1.id.to_s +
          "/orders/" + Order.last.id.to_s)
        expect(Order.last.approved).to be(false)
      end
    end
  end
end
