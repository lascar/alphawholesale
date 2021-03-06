require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe CustomersController, type: :controller do
  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let(:customer_hash) {{identifier: "customer3", email: "customer3@test.com",
                       tin: "en", country: "spain", password: "password",
                       entreprise_name: "star trek",
                       password_confirmation: "password"}}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when a customer is asked for creating
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user send for creating a customer" do
      before :each do
        post :create, params: {customer: customer_hash}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a customer is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating a customer" do
      before :each do
        sign_in(customer1)
        post :create, params: {customer: customer_hash}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when the customer is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating his identifier and email" do
      before :each do
        sign_in(customer1)
        post :create, params: {customer: customer_hash}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/customers/" +
                                            customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged broker
    # TEST when a customer is asked for creating
    # TEST then the page for the newly created customer is returned
    # TEST and a message of success is sent
    describe "as a logged broker asking for new customer page" do
      before :each do
        sign_in(broker1)
        post :create, params: {customer: customer_hash}
      end

      it "returns the new created customer page and
       returns the customer's page" do
        new_customer = Customer.find_by_identifier("customer3")
        expect(response.redirect_url).to match("/customers/" +
                                               new_customer.id.to_s)
        expect(flash.notice).to eq(
         I18n.t('controllers.customers.successfully_created'))
      end
    end
  end
end
