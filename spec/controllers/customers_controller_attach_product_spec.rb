require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe CustomersController, type: :controller do
  let(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let!(:product1) {create(:product, approved: true)}
  let!(:product2) {create(:product, approved: true)}
  let!(:product3) {create(:product, approved: true)}
  let!(:product4) {create(:product, approved: true)}

  let!(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #attach_product" do

    # TEST as a guest user
    # TEST when a customer is asked for the attach products page
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get 'attach_products', params: {id: customer1.to_param}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for the attach products page
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get 'attach_products', params: {id: customer1.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when he asks for the attach products page for an other customer
    # TEST when an other customer is asked for show
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking an other customer's page" do
      before :each do
        sign_in(customer1)
        get 'attach_products', params: {id: customer2.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when he asks for his attach products page
    # TEST then the customer is assigned
    # TEST and all the products of the customer are assigned but the products
    # TEST owned by an other customer
    # TEST and the customer's attached products page is returned
    describe "as a logged customer asking for his page" do
      before :each do
        customer1.products = [product1, product2]
        sign_in(customer1)

        get 'attach_products', params: {id: customer1.to_param}
      end

      it "assigns the customer and assigns all the customer's attached products
       and returns the customer's attach products page" do
        expect(assigns(:customer)).to eq(customer1)
        expect(assigns(:products).sort).to eq([product3, product4].sort)
        expect(response).to render_template(:attach_products)
      end
    end

    # TEST as a logged broker
    # TEST when the attached products page for a customer is asked
    # TEST then the customer is assigned
    # TEST and all the products of the customer are assigned
    # TEST and the customer's attached products page is returned
    describe "as a logged broker asking for a customer's page" do
      before :each do
        customer1.products = [product1, product2]
        sign_in(broker1)
        get 'attach_products', params: {id: customer1.to_param}
      end

      it "assigns the customer and assigns all the customer's offers
       and returns the customer's attach products page" do
        expect(assigns(:customer)).to eq(customer1)
        expect(assigns(:products).sort).to eq([product3, product4].sort)
        expect(response).to render_template(:attach_products)
      end
    end
  end
end
