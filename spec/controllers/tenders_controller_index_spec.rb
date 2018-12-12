require 'rails_helper'

RSpec.describe TendersController, type: :controller do

  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:tender1) {create(:tender, customer: customer1)}
  let!(:tender2) {create(:tender, customer: customer2)}

  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of tenders is asked for
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :index
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when the list of tenders is asked for
    # TEST then all the customer's tenders are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index
      end

      it "assigns all customer's tenders" do
        expect(assigns(:tenders).sort).to eq(
         Tender.where(customer_id: customer1.id).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of tenders is asked for
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :index
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

    # TEST as a logged broker
    # TEST when the list of tenders is asked for
    # TEST then all the tenders are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :index
      end

      it "assigns all tenders" do
        expect(assigns(:tenders).sort).to eq(Tender.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end
  end
end
