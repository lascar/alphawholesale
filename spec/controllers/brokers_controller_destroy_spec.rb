require 'rails_helper'

RSpec.describe BrokersController, type: :controller do
  let!(:broker1) {create(:broker)}
  let!(:broker2) {create(:broker, identifier: "broker2",
                                  email: "broker2@test.com")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when a broker is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the broker is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: broker1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.broker.unauthenticated'))
      end

      it "does not destroy the broker" do
        expect(Broker.find_by_id(broker1.id)).to eq(broker1)
      end
    end

    # TEST as a logged customer
    # TEST when a broker is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the broker is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: broker1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the broker" do
        expect(Broker.find_by_id(broker1.id)).to eq(broker1)
      end
    end

    # TEST as a logged supplier
    # TEST when a broker is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the broker is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: broker1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the broker" do
        expect(Broker.find_by_id(broker1.id)).to eq(broker1)
      end
    end

    # TEST as a logged broker
    # TEST when a other broker is asked for destroying
    # TEST then the list of brokers is returned
    # TEST and a message of success in destroying is send
    # TEST and the broker is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: broker2.to_param}
      end

      it "returns the list of brokers" do
        expect(response.redirect_url).to eq("http://test.host/brokers")
      end

      it "returns the list of brokers" do
        expect(flash.notice).to match(
         I18n.t('controllers.brokers.successfully_destroyed'))
      end

      it "destroys the broker" do
        expect(Broker.find_by_id(broker2.id)).to be(nil)
      end
    end
  end
end
