require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, supplier_id: supplier1.id)}
  let!(:offer2) {create(:offer, supplier_id: supplier2.id)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when an offer is asked for destroying
    # TEST then 404 is returned
    describe "as guest user" do
			it "does not routes get /offers/1/edit to offers#edit" do
        expect{ delete :destroy, params: {offer_id: offer1.id} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged customer
    # TEST when a offer is asked for destroying
    # TEST then 404 is returned
    describe "as a logged customer" do
			it "does not routes delete /customers/1/offers/1 to offers#destroy" do
        sign_in(customer1)
        expect{ delete :destroy, params: {customer_id: customer1.id, offer_id: offer1.id} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged supplier
    # TEST when a offer that not belongs to the supplier is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the offer is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        # tested with supplier2.id too
        delete :destroy, params: {supplier_id: supplier1.id, id: offer2.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the offer" do
        expect(Offer.find_by_id(offer1.id)).to eq(offer1)
      end
    end

    # TEST as a logged supplier
    # TEST when a offer that belongs to the supplier is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the offer is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {supplier_id: supplier1.id, id: offer1.to_param}
      end

      it "returns the list of the supplier's offers" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s + "/offers/")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.offers.successfully_destroyed'))
      end

      it "destroys the offer" do
        expect(Offer.find_by_id(offer1.id)).to be(nil)
      end
    end
  end
end
