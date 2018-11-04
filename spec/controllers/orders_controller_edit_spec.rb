require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:order1) {create(:order, customer: customer1)}
  let!(:order2) {create(:order, customer: customer2)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a order is asked for edit
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :edit, params: {id: order1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.order.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a order is asked for edit
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: order1.to_param}
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
    # TEST when order owned by other customer is asked for editing
    # TEST then the customer's page is returned
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: order2.to_param}
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
    # TEST when order owned by the customer is asked for editing
    # TEST then the edited order is assigned
    # TEST and customers is not assigned
    # TEST and the customer is the customer's order
    # TEST and the new template is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: order1.to_param}
      end

      it "assigns a new order" do
        expect(assigns(:order).persisted?).to be(true)
      end

      it "does not assign customers" do
        expect(assigns(:customers)).to be(nil)
      end

      it "assigns the customer to the new order" do
        expect(assigns(:order).customer).to eq(customer1)
      end

      it "redirect to the newly created order" do
        expect(response).to render_template(:edit)
      end
    end

    # TEST as a logged broker
    # TEST when a order is asked for edit
    # TEST then the asked order is assigned
    # TEST and customers is assigned
    # TEST then the order's edit page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: order1.to_param}
      end

      it "assigns the order" do
        expect(assigns(:order)).to eq(order1)
      end

      it "assigns customers" do
        expect(assigns(:customers).sort).to eq(
         Customer.all.pluck(:identifier, :id).sort)
      end

      it "render the edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
