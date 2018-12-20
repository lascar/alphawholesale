require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe SuppliersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:supplier_hash) {{identifier: "supplier3", email: "supplier3@test.com",
                       tin: "en", country: "spain", password: "password",
                       entreprise_name: "star treck",
                       password_confirmation: "password"}}
  let(:customer1) {create(:customer)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when a supplier is asked for creating
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is sent
    describe "as guest user send for creating a supplier" do
      before :each do
        post :create, params: {supplier: supplier_hash}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is sent
    describe "as a logged customer asking for creating a supplier" do
      before :each do
        sign_in(customer1)
        post :create, params: {supplier: supplier_hash}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is sent
    describe "as a logged supplier asking for creating
     his identifier and email" do
      before :each do
        sign_in(supplier1)
        post :create, params: {supplier: supplier_hash}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
          "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

  end
end
