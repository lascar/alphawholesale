require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product, name: "product2")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a product is asked for edit
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :edit, params: {id: product1.to_param}
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
    # TEST when a product is asked for edit
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: product1.to_param}
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
    # TEST when a product is asked for edit
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: product1.to_param}
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
    # TEST when a product is asked for edit
    # TEST then the asked product is assigned
    # TEST then the product's edit page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: product1.to_param}
      end

      it "assigns the product" do
        expect(assigns(:product)).to eq(product1)
      end

      it "render the edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
