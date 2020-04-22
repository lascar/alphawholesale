require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product, name: "product2")}
  let(:product_hash) {{name: "product3"}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when product is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {broker_id: broker1.id, product: product_hash}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when product is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        post :create, params: {broker_id: broker1.id, product: product_hash}
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

    # TEST as a logged supplier
    # TEST when product is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {broker_id: broker1.id, product: product_hash}
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

    # TEST as a logged broker
    # TEST when product is asked for creating
    # TEST then a create product is assigned
    # TEST then the product's create page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {broker_id: broker1.id, product: product_hash}
      end

      it "assigns a new product" do
        expect(assigns(:product).persisted?).to be(true)
      end

      it "redirect to the newly created product" do
        product_id = assigns(:product).id.to_s
        expect(response.redirect_url).to eq("http://test.host/brokers/#{broker1.id.to_s}/products/#{product_id}")
      end
    end
  end
end
