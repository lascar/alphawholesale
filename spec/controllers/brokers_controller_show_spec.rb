require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe BrokersController, type: :controller do
  let!(:broker1) {create(:broker)}
  let!(:broker2) {create(:broker, identifier: "broker2",
                                  email: "broker2@test.com")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let!(:offer1) {create(:offer, date_start: Time.now, date_end: Time.now + 5.days)}
  let!(:order1) {create(:order, offer: offer1)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a broker is asked for showing
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: broker1.to_param}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a broker is asked for showing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: broker1.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when a broker is asked for
    # TEST then the root page for suppliers is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking a broker's page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: broker1.to_param}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged broker
    # TEST when the broker is asked for his page
    # TEST then the broker is assigned
    # TEST and the suppliers without approved is assigned
    # TEST and the customers without approved is assigned
    # TEST and the products
    # TEST and the offers without approved is assigned
    # TEST and the orders without approved is assigned
    # TEST and the show template is rendered
    describe "as a logged broker asking for his page" do
      before :each do
        supplier1.approved = false
        supplier1.save
        customer1.approved = false
        customer1.save
        sign_in(broker1)
        get :show, params: {id: broker1.to_param}
      end

      it "assigns the broker and assigns the suppliers_without_approved and
       assigns the customers_without_approved and
       assigns the products and
       assigns the offers_without_approved and
       assigns the orders_without_approved and renders the show template" do
        expect(assigns(:broker)).to eq(broker1)
        expect(assigns(:suppliers_without_approved)).to eq(Supplier.with_approved(false))
        expect(assigns(:customers_without_approved)).to eq(Customer.with_approved(false))
        expect(assigns(:offers_without_approved).count).to eq(1)
        expect(assigns(:orders_without_approved).count).to eq(1)
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when an othor broker is asked for
    # TEST then the asked broker is assigned
    # TEST and the show template is rendered
    describe "as a logged broker asking for an other broker's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: broker2.to_param}
      end

      it "assigns the broker asked for and renders the show template" do
        expect(assigns(:broker)).to eq(broker2)
        expect(response).to render_template(:show)
      end
    end
  end
end
