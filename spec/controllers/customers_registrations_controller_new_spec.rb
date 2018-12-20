require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe Customers::RegistrationsController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let(:supplier_hash) {{identifier: "supplier2", email: "supplier2@test.com",
                       tin: "en", country: "spain", entreprise_name: "star treck",
                       password: "password", password_confirmation: "password"}}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "GET #new" do

    # TEST as a logged customer
    # TEST when a customer is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating a customer" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:customer]
        sign_in(customer1)
        get :new
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
                I18n.t('devise.failure.already_authenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when the customer is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for creating his identifier and email" do
      before :each do
        @request.env["devise.mapping"] = Devise.mappings[:supplier]
        sign_in(supplier1)
        get :new
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.failure.already_authenticated'))
      end
    end
  end
end
