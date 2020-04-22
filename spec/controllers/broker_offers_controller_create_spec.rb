require 'rails_helper'

RSpec.describe BrokerOffersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let(:concrete_product1) {create(:concrete_product, suppliers: [supplier1])}
  let(:offer_hash) {{ quantity: 1, unit_price_supplier: 1, concrete_product_id: concrete_product1.id}}

  describe "POST #create" do

    # TEST as a logged broker
    # TEST when offer is asked for creating without supplier
    # TEST then the newly created offer is assigned
    # TEST and suppliers is assigned
    # TEST and the new template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {broker_id: broker1.id, offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).persisted?).to be(false)
      end

      it "renders the new template" do
        expect(response.redirect_url).to eq("http://test.host/brokers/#{broker1.id.to_s}/offers/new")
      end
    end

    # TEST as a logged broker
    # TEST when offer is asked for creating with supplier
    # TEST then the newly created offer is assigned
    # TEST and the new template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        offer_hash[:supplier_id] = supplier1.id
        post :create, params: {broker_id: broker1.id, offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).persisted?).to be(true)
      end

      it "redirect to the newly created offer" do
        offer_id = assigns(:offer).id.to_s
        expect(response.redirect_url).to eq("http://test.host/brokers/#{broker1.id.to_s}/suppliers/#{supplier1.id}/offers/" + offer_id)
      end
    end
  end
end
