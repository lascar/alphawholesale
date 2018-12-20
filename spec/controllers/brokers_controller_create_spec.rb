require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe BrokersController, type: :controller do
  let!(:broker1) {create(:broker)}
  let!(:broker2) {create(:broker, identifier: "broker2",
                                      email: "broker2@test.com")}
  let(:broker_hash) {{identifier: "broker3", email: "broker3@test.com",
                       locale: "en", password: "password",
                       password_confirmation: "password"}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when broker is asked for creating
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user send for creating a broker" do
      before :each do
        post :create, params: {broker: broker_hash}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when broker is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for creating a broker" do
      before :each do
        sign_in(customer1)
        post :create, params: {broker: broker_hash}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when broker is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for creating
     his identifier and email" do
      before :each do
        sign_in(supplier1)
        post :create, params: {broker: broker_hash}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged broker
    # TEST when broker is asked for creating
    # TEST then the new broker is created
    describe "as a logged broker asking for new broker page" do
      before :each do
        sign_in(broker1)
        post :create, params: {broker: broker_hash}
      end

      it "returns the broker's page" do
        expect(Broker.last.identifier).to eq("broker3")
      end
    end
  end
end
