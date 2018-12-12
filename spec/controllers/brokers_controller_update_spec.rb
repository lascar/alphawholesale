require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe BrokersController, type: :controller do
  let!(:broker1) {create(:broker)}
  let!(:broker2) {create(:broker, identifier: "broker2",
                                  email: "broker2@test.com")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when a broker is asked for updating
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user send for updating a broker" do
      before :each do
        put :update,
         params: {id: broker1.to_param,
                  broker: (attributes_for(:broker,
                                            identifier: "broker3",
                                            email: "broker3@test.com"))}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a broker is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for updating a broker" do
      before :each do
        sign_in(customer1)
        put :update,
         params: {id: broker1.to_param,
                  broker: (attributes_for(:broker,
                                            identifier: "broker3",
                                            email: "broker3@test.com"))}
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
    # TEST when an other broker is asked for updating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for updating an other broker" do
      before :each do
        sign_in(supplier1)
        put :update,
         params: {id: broker1.to_param,
                  broker: (attributes_for(:broker,
                                            identifier: "broker3",
                                            email: "broker3@test.com"))}
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

    # TEST as a logged broker
    # TEST when the broker is asked for updating himself
    # TEST then the details are changed
    # TEST and the request is redirect at the modified broker's show page
    describe "as a logged broker asking for updating himself" do
      before :each do
        sign_in(broker1)
        put :update,
         params: {id: broker1.to_param,
                  broker: (attributes_for(:broker,
                                            identifier: "broker3",
                                            email: "broker3@test.com"))}
      end

      it "the identifier has changed" do
        expect(Broker.find(broker1.id).identifier).to eq("broker3")
      end

      it "the modified broker's page is returned" do
        expect(response.redirect_url).to eq(
         "http://test.host/brokers/" + broker1.id.to_s)
      end
    end

    describe "as a logged broker asking for updating an other broker" do
      before :each do
        sign_in(broker1)
        put :update,
         params: {id: broker2.to_param,
                  broker: (attributes_for(:broker,
                                            identifier: "broker3",
                                            email: "broker3@test.com"))}
      end

      it "the email has changed" do
        expect(Broker.find(broker2.id).identifier).to eq("broker3")
      end

      it "the broker's page is retured" do
        expect(response.redirect_url).to eq(
         "http://test.host/brokers/" + broker2.id.to_s)
      end
    end
  end
end
