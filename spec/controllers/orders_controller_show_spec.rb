require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:order1) {create(:order, customer: customer1)}
  let!(:order2) {create(:order, customer: customer2)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a order is asked for showing
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: order1.to_param}
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
    # TEST when a order is asked for showing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: order1.to_param}
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
    # TEST when an other's customer order is asked for showing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer2)
        get :show, params: {id: order1.to_param}
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
        get :show, params: {id: order1.to_param}
      end

      it "assigns the order" do
        expect(assigns(:order)).to eq(order1)
      end

      it "returns the order's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when a order is asked for showing
    # TEST then the order is assigned
    # TEST then the order's show page is rendered
    describe "as a logged broker asking for a order's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: order1.to_param}
      end

      it "assigns the order" do
        expect(assigns(:order)).to eq(order1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
