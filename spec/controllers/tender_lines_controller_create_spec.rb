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
                              unit: 1, unit_price: 2.09)}
  let!(:tender_line2) {create(:tender_line, tender: tender2, product: product1,
                              unit: 2, unit_price: 4.18)}
  let!(:tender_line_hash) {{ tender_id: tender1.id, product_id: product1.id,
                             unit: 3}}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when tender_line is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {tender_line: tender_line_hash}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when tender_line is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {tender_line: tender_line_hash}
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
    # TEST when tender_line is asked for creating
    # TEST then a new tender_line is assigned
    # TEST and the tender_line's attributes are initialized correctly
    # TEST and it's redirected to the tender_line
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        tender_line_hash[:customer_id] = customer1.id
        post :create, params: {tender_line: tender_line_hash}
      end

      it "assigns the updated tender_line" do
        expect(assigns(:tender_line).persisted?).to be(true)
      end

      it "updated the attributes" do
        expect(assigns(:tender_line).unit).to eq(tender_line_hash[:unit])
      end

      it "redirect to the updated tender_line" do
        expect(response.redirect_url).to eq(
          "http://test.host/customers/" + customer1.id.to_s +
          "/tender_lines/" + TenderLine.last.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when tender_line is asked for creating without tender
    # TEST then the attributes are not changed
    # TEST and the edit template is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        tender_line_hash[:tender_id] = nil
        post :create, params: {tender_line: tender_line_hash}
      end

      it "does not change the attributes" do
        expect(assigns(:tender_line).persisted?).to be(false)
      end

      it "renders the edit template" do
        expect(response).to render_template(:new)
      end
    end

    # TEST as a logged broker
    # TEST when tender_line is asked for creating with supplier
    # TEST then the attributes are initalized correctly
    # TEST and it's redirected to the tender_line
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {tender_line: tender_line_hash}
      end

      it "assigns the updated tender_line" do
        expect(assigns(:tender_line).persisted?).to be(true)
      end

      it "initializes the attributes" do
        expect(assigns(:tender_line).unit).to eq(tender_line_hash[:unit])
      end

      it "redirect to the newly updated tender_line" do
        expect(response.redirect_url).to eq(
          "http://test.host/tender_lines/" + TenderLine.last.id.to_s)
      end
    end
  end
end
