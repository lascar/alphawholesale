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
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {order: order_hash}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when order is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {order: order_hash}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
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
        post :create, params: {order: order_hash}
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

    # TEST as a logged broker
    # TEST when order is asked for creating without customer
    # TEST then the attributes are not changed
    # TEST and the edit template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        order_hash[:customer_id] = nil
        post :create, params: {order: order_hash}
      end

      it "does not change the attributes and renders the edit template" do
        expect(assigns(:order).persisted?).to be(false)
        expect(response.redirect_url).to eq(
         "http://test.host/orders/new?offer_id=" + offer1.id.to_s)
      end
    end

  end
end
