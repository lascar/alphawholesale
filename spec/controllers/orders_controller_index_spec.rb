require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer)}
  let!(:supplier1) {create(:supplier, unit_type: "kilogram")}
  let!(:supplier2) {create(:supplier, unit_type: "pound")}
  let!(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, approved: true, quantity: 10,
                                unit_price_supplier: 0.1, unit_price_broker: 0.2,
                                supplier_id: supplier1.id)}
  let!(:offer2) {create(:offer, approved: true, quantity: 20,
                                unit_price_supplier: 0.3, unit_price_broker: 0.4,
                                supplier_id: supplier2.id)}
  let!(:offer3) {create(:offer, approved: true,quantity: 30,
                                unit_price_supplier: 0.5, unit_price_broker: 0.6,
                                supplier_id: supplier1.id)}
  let!(:order1) {create(:order, approved: true, quantity: 5, offer_id: offer1.id,
                                customer_id: customer1.id)}
  let!(:order2) {create(:order, approved: true, quantity: 15, offer_id: offer2.id,
                                customer_id: customer2.id)}
  let!(:order3) {create(:order, approved: false, quantity: 25, offer_id: offer3.id,
                                customer_id: customer1.id)}

  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of orders is asked for
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :index
      end

      it "returns the root page and returns a non authenticated message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when the list of orders is asked for
    # TEST then all the customer's orders are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index
      end

      it "assigns all customer's orders and renders the index" do
        expect(assigns(:orders).sort).to eq(
         Order.where(customer_id: customer1.id).sort)
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of orders is asked for
    # TEST then all the orders approved that are from an this supplier's offer
    # TEST are assigned
    # TEST and it renders the index
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :index
      end

      it "assigns all approved supplier's relative orders and renders the index" do
        orders = Order.joins(:offer).where('offers.supplier_id = ?', supplier1.id).
          with_approved(true).sort
        expect(assigns[:orders].sort).to eq(orders)
        expect(response).to render_template(:index)
      end
    end
  end
end
