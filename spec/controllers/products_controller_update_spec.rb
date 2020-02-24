require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product, name: "product2")}
  let(:product_hash) {{name: "product3"}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when product is asked for updating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        put :update, params: {id: product1.to_param, product: product_hash}
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
    # TEST when a product is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        put :update, params: {id: product1.to_param, product: product_hash}
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
    # TEST when a product is asked for updating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {id: product1.to_param, product: product_hash}
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
    # TEST when a product is asked for updating
    # TEST then a update product is assigned
    # TEST then the product's update page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {id: product1.to_param, product: product_hash}
      end

      it "changes the product" do
        expect(assigns(:product).name).to eq(product_hash[:name])
      end

      it "redirect to the newly updated product" do
        expect(response.redirect_url).to eq("http://test.host/products/" +
                                            product1.id.to_s)
      end
    end
  end
end
