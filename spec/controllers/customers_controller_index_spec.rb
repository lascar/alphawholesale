require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: "customer2",
                                      email: "customer2@test.com")}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #index" do

    # TEST as a guest user
    # TEST when the list of customers is asked for
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :index
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.customer.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when the list of customers is asked for
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index
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

    # TEST as a logged supplier
    # TEST when the list of customers is asked for
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(supplier1)
        get :index
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

  end
end
