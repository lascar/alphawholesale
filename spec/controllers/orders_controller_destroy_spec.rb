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
    # TEST when order is asked for destroying
    # TEST then it is routed to routing error
    it "does not routes delete /orders/1 to orders#destroy" do
      expect(:delete => "/orders/1").to route_to(controller: 'welcome',
                                                 action: 'routing_error',
                                                   url: 'orders/1')
    end

    # TEST as a logged supplier
    # TEST when order is asked for destroying
    # TEST then it is routed to routing error
    it "does not routes delete /orders/1 to orders#destroy" do
      sign_in(supplier1)
      expect(:delete => "/suppliers/#{supplier1.id.to_s}/orders/1").to route_to(
        controller: 'welcome', action: 'routing_error',
        url: "suppliers/#{supplier1.id.to_s}/orders/1")
    end

    # TEST as a logged customer
    # TEST when a order that not belongs to the customer is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the order is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        # tried too with customer2.id
        delete :destroy, params: {customer_id: customer1.id, id: order2.to_param}
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
        delete :destroy, params: {customer_id: customer1.id, id: order1.to_param}
      end

      it "returns the list of the customer's orders" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s + "/orders/")
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
