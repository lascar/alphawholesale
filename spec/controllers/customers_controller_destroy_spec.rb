require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when a customer is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the customer is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: customer1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end

      it "does not destroy the customer" do
        expect(Customer.find_by_id(customer1.id)).to eq(customer1)
      end
    end

    # TEST as a logged customer
    # TEST when a customer is asked for destroying himself
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the customer is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: customer1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the customer" do
        expect(Customer.find_by_id(customer1.id)).to eq(customer1)
      end
    end

    # TEST as a logged customer
    # TEST when an other customer is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the customer is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: customer2.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the customer" do
        expect(Customer.find_by_id(customer2.id)).to eq(customer2)
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the customer is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: customer1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the customer" do
        expect(Customer.find_by_id(customer1.id)).to eq(customer1)
      end
    end

    # TEST as a logged broker
    # TEST when a customer is asked for destroying
    # TEST then the list of customers is returned
    # TEST and a message of success in destroying is send
    # TEST and the customer is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: customer1.to_param}
      end

      it "returns the list of customers" do
        expect(response.redirect_url).to eq("http://test.host/customers")
      end

      it "returns the list of customers" do
        expect(flash.notice).to match(
         I18n.t('controllers.customers.successfully_destroyed'))
      end

      it "returns the list of customers" do
        expect(Customer.find_by_id(customer1.id)).to be(nil)
      end
    end
  end
end
