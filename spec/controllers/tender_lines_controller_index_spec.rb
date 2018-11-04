require 'rails_helper'

RSpec.describe TenderLinesController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let(:date) {Time.now}
  let!(:tender1) {create(:tender, customer: customer1,
                         date_start: date, date_end: date + 1.months)}
  let!(:tender2) {create(:tender, customer: customer2)}
  let!(:tender_line1) {create(:tender_line, tender: tender1, product: product1,
                              unit: 1, unit_type: 'kilogram', unit_price: 2.09,
                              currency: 'euro')}
  let!(:tender_line2) {create(:tender_line, tender: tender2, product: product1,
                              unit: 1, unit_type: 'kilogram', unit_price: 2.09,
                              currency: 'euro')}


  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of tender_lines is asked for
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :index, params: {tender_id: tender1.id}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.broker.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a tender list of tender_lines is asked for
    # TEST owned by other customer
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer2)
        get :index, params: {tender_id: tender1.id}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer2.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when a tender list of tender_lines is asked for
    # TEST owned by the customer
    # TEST then all the customer's tender_lines are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index, params: {tender_id: tender1.id}
      end

      it "assigns all customer's tender_lines" do
        expect(assigns(:tender_lines).sort).to eq(
         TenderLine.where(tender_id: tender1.id).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of tender_lines is asked for
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :index, params: {tender_id: tender1.id}
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
    # TEST when the list of tender_lines is asked for
    # TEST then all the tender_lines are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :index
      end

      it "assigns all tender_lines" do
        expect(assigns(:tender_lines).sort).to eq(TenderLine.by_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end
  end
end
