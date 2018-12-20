require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a customer is asked for editing
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user asking for a customer's editing page" do
      it "returns the root page and returns a non authorized message" do
        get :edit, params: {id: customer1.to_param}
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for editing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for a supplier's editing page" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: customer1.to_param}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when an other customer is asked for editing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for
     an other customer's editing page" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: customer2.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when a customer is asked his page for editing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for his editing page" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: customer1.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged broker
    # TEST when a customer page for editing is asked
    # TEST then the asked customer is assigned
    describe "as a logged broker asking for new customer page" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: customer1.to_param}
      end

      it "assigns the asked customer" do
        expect(assigns(:customer)).to eq(customer1)
      end
    end
  end
end
