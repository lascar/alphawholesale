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
    # TEST when an offer is asked for updating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        put :update, params: {id: offer1.to_param, offer: offer_hash}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when an offer is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        put :update, params: {id: offer1.to_param, offer: offer_hash}
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
    # TEST when an other supplier's offer is asked for updating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {id: offer2.to_param, offer: offer_hash}
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
        put :update, params: {id: offer1.to_param, offer: offer_hash}
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

    # TEST as a logged broker
    # TEST when an offer is asked for updating without supplier
    # TEST then the attributes are not changed
    # TEST and the edit template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        offer_hash[:supplier_id] = nil
        put :update, params: {id: offer1.to_param, offer: offer_hash}
      end

      it "does not change the attributes" do
        expect(assigns(:offer).quantity).to be(offer1.quantity)
      end

      it "renders the edit template" do
        expect(response.redirect_url).to eq(
         "http://test.host/offers/new")
      end
    end

    # TEST as a logged broker
    # TEST when an offer is asked for updating with supplier
    # TEST then the attributes are changed
    # TEST and it's redirected to the offer
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {id: offer1.to_param, offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).quantity).to be(offer_hash[:quantity])
      end

      it "redirect to the newly updated offer" do
        expect(response.redirect_url).to eq(
         "http://test.host/offers/" + offer1.id.to_s)
      end
    end
  end
end
