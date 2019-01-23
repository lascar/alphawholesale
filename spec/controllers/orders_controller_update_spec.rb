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

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when an order is asked for updating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        put :update, params: {id: order1.to_param, order: order_hash}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when an order is asked for updating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {id: order1.to_param, order: order_hash}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when an other customer's order is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        put :update, params: {id: order2.to_param, order: order_hash}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when an order owned by this customer is asked for updating
    # TEST then a updated order is assigned
    # TEST and the order's attributes are updated
    # TEST and it's redirected to the order
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        order_hash[:customer_id] = customer1.id
        put :update, params: {id: order1.to_param, order: order_hash}
      end

      it "assigns the updated order" do
        expect(assigns(:order).persisted?).to be(true)
      end

      it "updated the attributes" do
        expect(assigns(:order).quantity).to eq(order_hash[:quantity])
      end

      it "redirect to the updated order" do
        expect(response.redirect_url).to eq(
          "http://test.host/customers/" + customer1.id.to_s +
         "/orders/" + order1.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when an order is asked for updating without supplier
    # TEST then the attributes are not changed
    # TEST and the edit template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        order_hash[:customer_id] = nil
        put :update, params: {id: order1.to_param, order: order_hash}
      end

      it "does not change the attributes" do
        expect(Order.find(order1.id).quantity).to eq(order1.quantity)
      end

      it "redirect to edit" do
        expect(response.redirect_url).to eq(
          'http://test.host/orders/' + order1.id.to_s + '/edit')
      end
    end

    # TEST as a logged broker
    # TEST when an order is asked for updating with supplier
    # TEST then the attributes are changed
    # TEST and it's redirected to the order
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {id: order1.to_param, order: order_hash}
      end

      it "assigns the updated order" do
        expect(assigns(:order).persisted?).to be(true)
      end

      it "updated the attributes" do
        expect(assigns(:order).quantity).to eq(order_hash[:quantity])
      end

      it "redirect to the newly updated order" do
        expect(response.redirect_url).to eq(
         "http://test.host/orders/" + order1.id.to_s)
      end
    end
  end
end
