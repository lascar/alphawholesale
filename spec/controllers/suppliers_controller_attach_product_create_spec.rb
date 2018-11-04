require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier)}
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:product3) {create(:product)}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "POST #attach_product_create" do

    # TEST as a guest user
    # TEST when a supplier is asked for creating an attach products
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user send for creating a supplier attach product" do
      before :each do
        post :attach_products_create,
         params: {id: supplier1.id, products: [product1.id, product2.id]}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.supplier.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for creating an attach products
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating a supplier attach product" do
      before :each do
        sign_in(customer1)
        post :attach_products_create,
         params: {id: supplier1.id, products: [product1.id, product2.id]}
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
    # TEST when a supplier is asked for creating an attach products to an other supplier
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for creating attach product to an other supplier" do
      before :each do
        sign_in(supplier1)
        post :attach_products_create,
         params: {id: supplier2.id, products: [product1.id, product2.id]}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq("http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when a supplier is asked for attaching products to himself
    # TEST then the supplier's page is returned
    # TEST and the new products are attached
    # TEST and a message of success is sent
    describe "as a logged supplier creating an attachment to products" do
      before :each do
        supplier1.products = []
        sign_in(supplier1)
        post :attach_products_create,
         params: {id: supplier1.id, products: [product1.id, product2.id]}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq("http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "attaches the producs to the suppliers" do
        expect(Supplier.find(supplier1.id).products.sort).to eq(
         [product1, product2].sort)
      end
    end


    # TEST as a logged broker
    # TEST when a supplier is asked for attaching products
    # TEST then the supplier's page is returned
    # TEST and the new products are attached
    describe "as a logged supplier creating an attachment to products" do
      before :each do
        supplier1.products = []
        sign_in(broker1)
        post :attach_products_create,
         params: {id: supplier1.id, products: [product1.id, product2.id]}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq("http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "attaches the producs to the suppliers" do
        expect(Supplier.find(supplier1.id).products.sort).to eq(
         [product1, product2].sort)
      end

    end
  end
end
