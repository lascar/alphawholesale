require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier); }
  let(:concrete_product1) {create(:concrete_product, suppliers: [supplier1])}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:offer1) {create(:offer, supplier: supplier1, concrete_product: concrete_product1)}
  let!(:offer2) {create(:offer, supplier: supplier2, concrete_product: concrete_product1)}
  let(:offer_hash) {{ quantity: 1, unit_price_supplier: 1, supplier: supplier1, concrete_product_id: concrete_product1.id}}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when offer is asked for creating
    # TEST then 404 is returned
    describe "as guest user" do
			it "does not routes post /offers to offers#create" do
				expect{ post :create, params: {offer: offer_hash} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged customer
    # TEST when offer is asked for creating
    # TEST then 404 is returned
    describe "as a customer" do
			it "does not routes post /customers/1/offers to offers#create" do
				expect{ post :create, params: {customer_id: customer1.id, offer: offer_hash} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged supplier
    # TEST when offer is asked for creating
    # TEST then the newly created offer is assigned
    # TEST and the supplier is the supplier's offer
    # TEST and it's redirected to the newly offer
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {supplier_id: supplier1.id, offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).persisted?).to be(true)
      end

      it "does not assign suppliers" do
        expect(assigns(:suppliers)).to be(nil)
      end

      it "assigns the supplier to the new offer" do
        expect(assigns(:offer).supplier).to eq(supplier1)
      end

      it "redirect to the newly created offer" do
        offer = assigns(:offer)
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + offer.supplier_id.to_s +
         "/offers/" + offer.id.to_s)
      end
    end
  end
end
