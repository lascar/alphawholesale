require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:offer1) {create(:offer, supplier: supplier1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}
  let(:offer_hash) {{ quantity: 1, unit_price_supplier: 1, product_id: product1.id}}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when offer is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {offer: offer_hash}
      end

      context "when creating" do
        it {is_expected.to redirect_to "http://test.host/"}
        it {is_expected.to set_flash[:alert].to I18n.t(
         'devise.failure.offer.unauthenticated')}
      end
    end

    # TEST as a logged customer
    # TEST when offer is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        post :create, params: {offer: offer_hash}
      end

      context "when creating" do
        it {is_expected.to redirect_to(
         "http://test.host/customers/#{customer1.id.to_s}")}
        it {is_expected.to set_flash[:alert].to I18n.t(
         'devise.errors.messages.not_authorized')}
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
        post :create, params: {offer: offer_hash}
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

    # TEST as a logged broker
    # TEST when offer is asked for creating without supplier
    # TEST then the newly created offer is assigned
    # TEST and suppliers is assigned
    # TEST and the new template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).persisted?).to be(false)
      end

      it "renders the new template" do
        expect(response.redirect_url).to eq("http://test.host/offers/new")
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
        post :create, params: {offer: offer_hash}
      end

      it "assigns a new offer" do
        expect(assigns(:offer).persisted?).to be(true)
      end

      it "redirect to the newly created offer" do
        offer_id = assigns(:offer).id.to_s
        expect(response.redirect_url).to eq("http://test.host/offers/" + offer_id)
      end
    end
  end
end
