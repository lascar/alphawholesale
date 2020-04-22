require 'rails_helper'

RSpec.describe BrokerOffersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}
    let!(:offer1) {create(:offer, supplier: supplier1)}
  let(:offer_hash) {{ quantity: 5, unit_price_supplier: 5,
                      supplier_id: supplier1.id}}

  describe "PUT #update" do

    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        offer_hash[:supplier_id] = nil
        put :update, params: {broker_id: broker1.id, id: offer1.to_param, offer: offer_hash}
      end

      it "does not change the attributes" do
        expect(assigns(:offer).quantity).to be(offer1.quantity)
      end

      it "renders the edit template" do
        expect(response.redirect_url).to eq(
          "http://test.host/brokers/#{broker1.id.to_s}/offers/")
      end
    end

    # TEST as a logged broker
    # TEST when an offer is asked for updating with supplier
    # TEST then the attributes are changed
    # TEST and it's redirected to the offer
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {broker_id: broker1.id, id: offer1.to_param, offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).quantity).to be(offer_hash[:quantity])
      end

      it "redirect to the newly updated offer" do
        expect(response.redirect_url).to eq(
          "http://test.host/brokers/#{broker1.id.to_s}/suppliers/#{supplier1.id}/offers/" + offer1.id.to_s)
      end
    end
  end
end
