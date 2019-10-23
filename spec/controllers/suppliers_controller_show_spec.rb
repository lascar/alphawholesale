require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier_with_offers)}
  let!(:supplier2) {create(:supplier, identifier: "supplier2",
                                      email: "supplier2@test.com")}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a supplier is asked for show
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: supplier1.to_param}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for show
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: supplier1.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when an other supplier is asked for show
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking an other supplier's page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: supplier2.to_param}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for his page
    # TEST then the supplier is assigned
    # TEST and all the offers of the supplier are assigned
    # TEST and the supplier's show page is returned
    describe "as a logged supplier asking for his page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: supplier1.to_param}
      end

      it "assigns all the supplier's offers" do
        expect(assigns(:offers).sort).to eq(supplier1.offers.sort)
      end

    end

    # TEST as a logged broker
    # TEST when a supplier is asked for show
    # TEST then the supplier is assigned
    # TEST and all the offers of the supplier are assigned
    # TEST and the supplier's show page is returned
    describe "as a logged broker asking for a supplier's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: supplier1.to_param}
      end

      it "assigns all the supplier's offers" do
        expect(assigns(:offers).sort).to eq(supplier1.offers.sort)
      end

    end
  end
end
