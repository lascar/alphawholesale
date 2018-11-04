require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe CustomersController, type: :controller do
  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when a customer is asked for updating
    # TEST then the root page is return
    # TEST and a message of unauthenticated is send
    describe "as guest user send for updating a customer" do
      before :each do
        put :update,
         params: {id: customer1.to_param,
                  customer: (attributes_for(:customer,
                                            identifier: "customer3",
                                            email: "customer3@test.com"))}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.customer.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for updating
    # TEST then the supplier's page is return
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for updating a customer" do
      before :each do
        sign_in(supplier1)
        put :update,
         params: {id: customer1.to_param,
                  customer: (attributes_for(:customer,
                                            identifier: "customer3",
                                            email: "customer3@test.com"))}
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

    # TEST as a logged customer
    # TEST when an other customer is asked for updating
    # TEST then the customer's page is return
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for updating an other customer" do
      before :each do
        sign_in(customer1)
        put :update,
         params: {id: customer2.to_param,
                  customer: (attributes_for(:customer,
                                            identifier: "customer3",
                                            email: "customer3@test.com"))}
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
    # TEST when the customer is asked for updating his identifier and email
    # TEST then the identifier remains unchanged but the email does
    # TEST and a message ok for change is send
    # TEST and the request is redirect at the show page
    describe "as a logged customer asking for updating
     his identifier and email" do
      before :each do
        sign_in(customer1)
        put :update,
         params: {id: customer1.to_param,
                  customer: (attributes_for(:customer,
                                            identifier: "customer3",
                                            email: "customer3@test.com"))}
      end

      it "the identifier remains unchanged" do
        expect(Customer.find(customer1.id).identifier).to eq(
         Customer.find(customer1.id).identifier)
      end

      it "the email has changed" do
        expect(Customer.find(customer1.id).email).to eq("customer3@test.com")
      end

      it "the customer's page is retured" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when a customer is asked for updating his identifier and email
    # TEST then the identifier and the email are changed
    describe "as a logged broker asking for updating
     a customer's identifier and email" do
      before :each do
        sign_in(broker1)
        put :update,
         params: {id: customer1.to_param,
                  customer: (attributes_for(:customer,
                                            identifier: "customer3",
                                            email: "customer3@test.com"))}
      end

      it "changes the customer's identifier" do
        expect(Customer.find(customer1.id).identifier).to eq("customer3")
      end

      it "changes the customer's email" do
        expect(Customer.find(customer1.id).email).to eq("customer3@test.com")
      end
    end
  end
end
