require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe CustomersController, type: :controller do
  let(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer)}
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:product3) {create(:product)}
  let!(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #attach_product_create" do

    # TEST as a guest user
    # TEST when a customer is asked for creating an attach products
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user send for creating a customer attach product" do
      before :each do
        post :attach_products_create,
         params: {id: customer1.id, products: [product1.id, product2.id]}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for creating an attach products
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for creating a customer attach product" do
      before :each do
        sign_in(supplier1)
        post :attach_products_create,
         params: {id: customer1.id, products: [product1.id, product2.id]}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when a customer is asked for creating an attach products to an other customer
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating attach product to an other customer" do
      before :each do
        sign_in(customer1)
        post :attach_products_create,
         params: {id: customer2.id, products: [product1.id, product2.id]}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when a customer is asked for attaching products to himself
    # TEST then the customer's page is returned
    # TEST and the new products are attached
    # TEST and a message of success is sent
    describe "as a logged customer creating an attachment to products" do
      before :each do
        customer1.products = []
        sign_in(customer1)
        post :attach_products_create,
         params: {id: customer1.id, products: [product1.id, product2.id]}
      end

      it "returns the customer's page
       and attaches the producs to the customers" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(Customer.find(customer1.id).products.sort).to eq(
         [product1, product2].sort)
      end
    end


    # TEST as a logged broker
    # TEST when a customer is asked for attaching products
    # TEST then the customer's page is returned
    # TEST and the new products are attached
    describe "as a logged customer creating an attachment to products" do
      before :each do
        customer1.products = []
        sign_in(broker1)
        post :attach_products_create,
         params: {id: customer1.id, products: [product1.id, product2.id]}
      end

      it "returns the customer's page and
       attaches the producs to the customers" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(Customer.find(customer1.id).products.sort).to eq(
         [product1, product2].sort)
      end

    end
  end
end
