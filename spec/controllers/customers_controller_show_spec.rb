require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe CustomersController, type: :controller do
  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a customer is asked for show
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: customer1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.customer.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when an other customer is asked for show
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: customer2.to_param}
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

    # TEST as a logged customer
    # TEST when the customer is asked for his page
    # TEST then the customer is assigned
    # TEST then the customer's show page is returned
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: customer1.to_param}
      end

      it "assigns the customer" do
        expect(assigns(:customer)).to eq(customer1)
      end

      it "returns the customer's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for show
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking a customer's page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: customer1.to_param}
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
    # TEST when a customer is asked for show
    # TEST then the customer is assigned
    # TEST then the customer's show page is returned
    describe "as a logged broker asking for a customer's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: customer1.to_param}
      end

      it "assigns the customer" do
        expect(assigns(:customer)).to eq(customer1)
      end

      it "returns the customer's page" do
        expect(response).to render_template(:show)
      end
    end
  end
end
