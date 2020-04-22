require 'rails_helper'
# ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER

RSpec.describe Suppliers::RegistrationsController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier)}
  let(:supplier_hash) {{identifier: "supplier2", email: "supplier2@test.com",
                       tin: "en", country: "spain", entreprise_name: "star treck",
                       password: "password", password_confirmation: "password"}}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "GET #edit" do

    # TEST as guest user
    # TEST when a supplier is asked for editing the registration
    # TEST then the sign in for supplier is returned
    # TEST and a message of unauthenticated is send
    describe "as a logged customer asking for editing
      the registration of a supplier" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:supplier]
        get :edit, params: {id: supplier1}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/sign_in")
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating a supplier" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:supplier]
        sign_in(customer1)
        get :edit
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for editing the registration
      of an other supplier" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:supplier]
        sign_in(supplier1)
        get :edit, params: {id: supplier2}
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
                       I18n.t('devise.errors.messages.not_authorized'))
      end
    end
  end
end
