require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product, name: "product2")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #get_names" do

    # TEST as a guest user
    # TEST when product is asked for get_names
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :get_names
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.product.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when product is asked for get_names
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :get_names
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
    # TEST when product is asked for get_names
    # TEST then a get_names product is assigned
    # TEST then the product's get_names page is rendered
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :get_names
      end

      it "assigns all the existing in the db product name " do
        expect(assigns(:names).sort).to eq(Product.get_names.sort)
      end

      it "render the get_names template" do
        expect(response).to render_template(:get_names)
      end
    end

    # TEST as a logged broker
    # TEST when product is asked for get_names
    # TEST then a get_names product is assigned
    # TEST then the product's get_names page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :get_names
      end

      it "assigns all the existing in the db product name " do
        expect(assigns(:names).sort).to eq(Product.get_names.sort)
      end

      it "render the get_names template" do
        expect(response).to render_template(:get_names)
      end
    end
  end
end
