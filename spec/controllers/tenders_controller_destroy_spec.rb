require 'rails_helper'

RSpec.describe TendersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:tender1) {create(:tender, customer_id: customer1.id)}
  let!(:tender2) {create(:tender, customer_id: customer2.id)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when an tender is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the tender is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: tender1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "does not destroy the tender" do
        expect(Tender.find_by_id(tender1.id)).to eq(tender1)
      end
    end

    # TEST as a logged supplier
    # TEST when a tender is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the tender is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: tender1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the tender" do
        expect(Tender.find_by_id(tender1.id)).to eq(tender1)
      end
    end

    # TEST as a logged customer
    # TEST when a tender that not belongs to the customer is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the tender is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: tender2.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the tender" do
        expect(Tender.find_by_id(tender1.id)).to eq(tender1)
      end
    end

    # TEST as a logged customer
    # TEST when a tender that belongs to the customer is asked for destroying
    # TEST then the list of tenders is returned
    # TEST and a message of success in destroying is send
    # TEST and the tender is destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: tender1.to_param}
      end

      it "returns the list of the customer's tenders" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s + "/tenders")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.tenders.successfully_destroyed'))
      end

      it "destroys the tender" do
        expect(Tender.find_by_id(tender1.id)).to be(nil)
      end
    end


    # TEST as a logged broker
    # TEST when a tender  is asked for destroying
    # TEST then the list of tenders is returned
    # TEST and a message of success in destroying is send
    # TEST and the tender is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: tender1.to_param}
      end

      it "returns the list of tenders" do
        expect(response.redirect_url).to eq("http://test.host/tenders")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.tenders.successfully_destroyed'))
      end

      it "destroys the tender" do
        expect(Tender.find_by_id(tender1.id)).to be(nil)
      end
    end
  end
end
