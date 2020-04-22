require 'rails_helper'
# ONLY_CUSTOMER_CUSTOMER_OWNER_OR_BROKER

RSpec.describe Customers::RegistrationsController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer)}
  let(:customer_hash) {{identifier: "customer2", email: "customer2@test.com",
                       tin: "en", country: "spain", entreprise_name: "star treck",
                       password: "password", password_confirmation: "password"}}
  let(:broker1) {create(:broker)}

  describe "GET #edit" do

    # TEST as guest user
    # TEST when a customer is asked for editing the registration
    # TEST then the sign in for customer is returned
    # TEST and a message of unauthenticated is send
    describe "as a logged customer asking for editing
      the registration of a customer" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        get :edit, params: {id: customer1}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/sign_in")
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for creating a customer" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:supplier]
        sign_in(supplier1)
        get :edit
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when the customer is
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for editing the registration
      of an other customer" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        sign_in(customer1)
        get :edit, params: {id: customer2}
      end

      it "returns the customer's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
                       I18n.t('devise.errors.messages.not_authorized'))
      end
    end
  end
end
