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
                              unit: 2, unit_type: 'kilogram', unit_price: 4.18,
                              currency: 'euro')}
  let!(:tender_line_hash) {{ tender_id: tender1.id, product_id: product1.id,
                             unit: 3, unit_type: 'kilogram'}}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a tender_line is asked for showing
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: tender_line1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.tender_line.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a tender_line is asked for showing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: tender_line1.to_param}
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

    # TEST as a logged customer
    # TEST when an other's customer tender_line is asked for showing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer2)
        get :show, params: {id: tender_line1.to_param}
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
    # TEST when an tender_line owned by this customer is asked for showing
    # TEST then the tender_line is assigned
    # TEST and the tender_line's show page is rendered
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: tender_line1.to_param}
      end

      it "assigns the tender_line" do
        expect(assigns(:tender_line)).to eq(tender_line1)
      end

      it "returns the tender_line's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when a tender_line is asked for showing
    # TEST then the tender_line is assigned
    # TEST then the tender_line's show page is rendered
    describe "as a logged broker asking for a tender_line's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: tender_line1.to_param}
      end

      it "assigns the tender_line" do
        expect(assigns(:tender_line)).to eq(tender_line1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
