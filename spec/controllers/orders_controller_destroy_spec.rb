require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:order1) {create(:order, customer_id: customer1.id)}
  let!(:order2) {create(:order, customer_id: customer2.id)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when an order is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the order is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: order1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "does not destroy the order" do
        expect(Order.find_by_id(order1.id)).to eq(order1)
      end
    end

    # TEST as a logged supplier
    # TEST when a order is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the order is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: order1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the order" do
        expect(Order.find_by_id(order1.id)).to eq(order1)
      end
    end

    # TEST as a logged customer
    # TEST when a order that not belongs to the customer is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the order is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: order2.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the order" do
        expect(Order.find_by_id(order1.id)).to eq(order1)
      end
    end

    # TEST as a logged customer
    # TEST when a order that belongs to the customer is asked for destroying
    # TEST then the list of orders is returned
    # TEST and a message of success in destroying is send
    # TEST and the order is destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: order1.to_param}
      end

      it "returns the list of the customer's orders" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s + "/orders")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.orders.successfully_destroyed'))
      end

      it "destroys the order" do
        expect(Order.find_by_id(order1.id)).to be(nil)
      end
    end


    # TEST as a logged broker
    # TEST when a order  is asked for destroying
    # TEST then the list of orders is returned
    # TEST and a message of success in destroying is send
    # TEST and the order is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: order1.to_param}
      end

      it "returns the list of orders" do
        expect(response.redirect_url).to eq("http://test.host/orders")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.orders.successfully_destroyed'))
      end

      it "destroys the order" do
        expect(Order.find_by_id(order1.id)).to be(nil)
      end
    end
  end
end
