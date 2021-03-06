require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}
  let!(:order2) {create(:order, customer: customer2)}

  describe "GET #show" do
    # TEST as a guest user
    # TEST when order is asked for showing
    # TEST then it is routed to routing error
    it "does not routes /orders/1 to orders#show" do
      expect(:get => "/orders/1").to route_to(controller: 'welcome',
                                              action: 'routing_error',
                                              url: 'orders/1')
    end

    # TEST as a logged supplier
    # TEST when a order from an other supplier's offer is asked for showing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier2)
        get :show, params: {supplier_id: supplier1.id, id: order1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier2.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when an order from an offer owned by this supplier is asked for showing
    # TEST then the order is assigned
    # TEST and the order's show page is rendered
    describe "as a logged supplier asking for an order's page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {supplier_id: supplier1.id, id: order1.to_param}
      end

      it "assigns the order" do
        expect(assigns(:order)).to eq(order1)
      end

      it "returns the order's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged customer
    # TEST when an other's customer order is asked for showing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer2)
        get :show, params: {customer_id: customer1.id, id: order1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer2.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when an order owned by this customer is asked for showing
    # TEST then the order is assigned
    # TEST and the order's show page is rendered
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {customer_id: customer1.id, id: order1.to_param}
      end

      it "assigns the order" do
        expect(assigns(:order)).to eq(order1)
      end

      it "returns the order's page" do
        expect(response).to render_template(:show)
      end
    end
  end
end
