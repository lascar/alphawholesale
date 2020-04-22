require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:offer1) {create(:offer, supplier: supplier1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}
  let(:offer_hash) {{ quantity: 5, unit_price_supplier: 5,
                      product_id: product1.id, supplier_id: supplier1.id}}

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when offer is asked for updating
    # TEST then 404 is returned
    describe "as guest user" do
			it "does not routes put /offers/1 to offers#create" do
        expect{ put :update, params: {offer_id: offer1.id,offer: offer_hash} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged customer
    # TEST when offer is asked for updating
    # TEST then 404 is returned
    describe "as a customer" do
			it "does not routes put /customers/1/offers/1 to offers#update" do
        expect{ post :create, params: {customer_id: customer1.id,
                                       offer_id: offer1.id, offer: offer_hash} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged supplier
    # TEST when an other supplier's offer is asked for updating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {supplier_id: supplier1.id, id: offer2.to_param, offer: offer_hash}
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

    # TEST as a logged supplier
    # TEST when an offer owned by this supplier is asked for updating
    # TEST then a updated offer is assigned
    # TEST and the offer's attributes are updated
    # TEST and it's redirected to the offer
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        offer_hash[:supplier_id] = supplier1.id
        put :update, params: {supplier_id: supplier1.id, id: offer1.to_param, offer: offer_hash}
      end

      it "assigns the updated offer" do
        expect(assigns(:offer).quantity).to be(Offer.find(offer1.id).quantity)
      end

      it "updated the attributes" do
        expect(Offer.find(offer1.id).quantity).to eq(
         offer_hash[:quantity])
      end

      it "redirect to the updated offer" do
        expect(response.redirect_url).to eq(
          "http://test.host/suppliers/" + supplier1.id.to_s +
         "/offers/" + offer1.id.to_s)
      end
    end
  end
end
