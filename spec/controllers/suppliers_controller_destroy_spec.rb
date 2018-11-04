require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier, identifier: "supplier2",
                                      email: "supplier2@test.com")}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when a supplier is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the supplier is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: supplier1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.supplier.unauthenticated'))
      end

      it "does not destroy the supplier" do
        expect(Supplier.find_by_id(supplier1.id)).to eq(supplier1)
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the supplier is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: supplier1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the supplier" do
        expect(Supplier.find_by_id(supplier1.id)).to eq(supplier1)
      end
    end

    # TEST as a logged supplier
    # TEST when an other supplier is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the supplier is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: supplier2.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the supplier" do
        expect(Supplier.find_by_id(supplier2.id)).to eq(supplier2)
      end
    end

    # TEST as a logged supplier
    # TEST when a supplier is asked himself for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the supplier is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: supplier1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the supplier" do
        expect(Supplier.find_by_id(supplier1.id)).to eq(supplier1)
      end
    end

    # TEST as a logged broker
    # TEST when a supplier is asked for destroying
    # TEST then the list of suppliers is returned
    # TEST and a message of success in destroying is send
    # TEST and the supplier is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: supplier1.to_param}
      end

      it "returns the list of suppliers" do
        expect(response.redirect_url).to eq("http://test.host/suppliers")
      end

      it "returns the list of suppliers" do
        expect(flash.notice).to match(
         I18n.t('controllers.suppliers.successfully_destroyed'))
      end

      it "returns the list of suppliers" do
        expect(Supplier.find_by_id(supplier1.id)).to be(nil)
      end
    end
  end
end
