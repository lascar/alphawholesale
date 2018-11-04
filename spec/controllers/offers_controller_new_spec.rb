require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, supplier: supplier1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when offer is asked for new
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :new
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.offer.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when offer is asked for new
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new
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
    # TEST when offer is asked for new
    # TEST then a new offer is assigned
    # TEST and the new offer's supplier is the supplier
    # TEST and suppliers is not assigned
    # TEST and the offer's new page is rendered
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :new
      end

      it "assigns a offer new" do
        expect(assigns(:offer).persisted?).to be(false)
      end

      it "puts the supplier as the new offer's supplier" do
        expect(assigns(:offer).supplier_id).to be(supplier1.id)
      end

      it "does not assign suppliers" do
        expect(assigns(:suppliers)).to be(nil)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end

    # TEST as a logged broker
    # TEST when offer is asked for new
    # TEST then a new offer is assigned
    # TEST and suppliers is assigned
    # TEST and the offer's new page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new
      end

      it "assigns a offer new" do
        expect(assigns(:offer).persisted?).to be(false)
      end

      it "assigns suppliers" do
        expect(assigns(:suppliers).sort).to eq(
         Supplier.all.pluck(:identifier, :id).sort)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end
