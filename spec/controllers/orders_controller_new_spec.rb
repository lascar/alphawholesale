require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}
  let!(:order2) {create(:order, customer: customer2, offer: offer1)}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when order is asked for new
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :new, params: {offer_id: offer1}
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
    # TEST when order is asked for new
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :new, params: {offer_id: offer1}
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
    # TEST when order is asked for new
    # TEST then a new order is assigned
    # TEST and the new order's customer is the customer
    # TEST and the order's new page is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new, params: {offer_id: offer1}
      end

      it "assigns a order new" do
        expect(assigns(:order).persisted?).to be(false)
      end

      it "puts the customer as the new order's customer" do
        expect(assigns(:order).customer_id).to be(customer1.id)
      end

      it "does not assign customers" do
        expect(assigns(:customers)).to be(nil)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end

    # TEST as a logged broker
    # TEST when order is asked for new
    # TEST then a new order is assigned
    # TEST and customers is assigned
    # TEST and the order's new page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new, params: {offer_id: offer1}
      end

      it "assigns a order new" do
        expect(assigns(:order).persisted?).to be(false)
      end

      it "assigns customers" do
        expect(assigns(:customers).sort).to eq(
         Customer.all.pluck(:identifier, :id).sort)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end
