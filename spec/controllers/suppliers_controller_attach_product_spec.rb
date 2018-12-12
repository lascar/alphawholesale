require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier, identifier: "supplier2",
                                      email: "supplier2@test.com")}
  let!(:product1) {create(:product, approved: true)}
  let!(:product2) {create(:product, approved: true)}
  let!(:product3) {create(:product)}
  let!(:product4) {create(:product)}

  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "POST #attach_product" do

    # TEST as a guest user
    # TEST when a supplier is asked for the attach products page
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get 'attach_products', params: {id: supplier1.to_param}
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
    # TEST when a supplier is asked for the attach products page
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get 'attach_products', params: {id: supplier1.to_param}
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
    # TEST when he asks for the attach products page for an other supplier
    # TEST when an other supplier is asked for show
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking an other supplier's page" do
      before :each do
        sign_in(supplier1)
        get 'attach_products', params: {id: supplier2.to_param}
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

    # TEST as a logged supplier
    # TEST when he asks for his attach products page
    # TEST then the supplier is assigned
    # TEST and all the products of the supplier are assigned but the products
    # TEST owned by an other supplier
    # TEST and the supplier's attached products page is returned
    describe "as a logged supplier asking for his page" do
      before :each do
        supplier1.products = [product1, product2]
        product4.supplier = supplier2
        product4.approved = false
        product4.save
        sign_in(supplier1)

        get 'attach_products', params: {id: supplier1.to_param}
      end

      it "assigns the supplier" do
        expect(assigns(:supplier)).to eq(supplier1)
      end

      it "assigns all the supplier's attached products" do
        expect(assigns(:products).sort).to eq([product1, product2].sort)
      end

      it "returns the supplier's attach products page" do
        expect(response).to render_template(:attach_products)
      end
    end

    # TEST as a logged broker
    # TEST when the attached products page for a supplier is asked
    # TEST then the supplier is assigned
    # TEST and all the products of the supplier are assigned
    # TEST and the supplier's attached products page is returned
    describe "as a logged broker asking for a supplier's page" do
      before :each do
        supplier1.products = [product1, product2]
        product4.supplier = supplier2
        product4.approved = false
        product4.save
        sign_in(broker1)
        get 'attach_products', params: {id: supplier1.to_param}
      end

      it "assigns the supplier" do
        expect(assigns(:supplier)).to eq(supplier1)
      end

      it "assigns all the supplier's offers" do
        expect(assigns(:products).sort).to eq([product1, product2].sort)
      end

      it "returns the supplier's attach products page" do
        expect(response).to render_template(:attach_products)
      end
    end
  end
end
