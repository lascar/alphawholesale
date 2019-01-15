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

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
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

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
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

      it "assigns a order new and puts the customer as the new order's customer and
          does not assign customers and render the new template" do
        expect(assigns(:order).persisted?).to be(false)
        expect(assigns(:order).customer_id).to be(customer1.id)
        expect(assigns(:customers)).to be(nil)
        expect(response).to render_template(:new)
      end
    end

  end
end
