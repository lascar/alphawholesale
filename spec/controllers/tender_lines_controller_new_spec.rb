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
  let(:tender_line_hash) {{ tender_id: tender1.id}}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when tender_line is asked for new
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :new, params: {tender_line: tender_line_hash}
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
    # TEST when tender_line is asked for new
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :new, params: {tender_line: tender_line_hash}
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
    # TEST when tender_line is asked for new
    # TEST then a new tender_line is assigned
    # TEST and the new tender_line's tender is the tender
    # TEST and the tender_line's new page is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new, params: {tender_line: tender_line_hash}
      end

      it "assigns a tender_line new" do
        expect(assigns(:tender_line).persisted?).to be(false)
      end

      it "puts the tender as the new tender_line's tender" do
        expect(assigns(:tender_line).tender_id).to be(tender1.id)
      end

      it "does not assign customers" do
        expect(assigns(:customers)).to be(nil)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end

    # TEST as a logged broker
    # TEST when tender_line is asked for new
    # TEST then a new tender_line is assigned
    # TEST and customers is assigned
    # TEST and the tender_line's new page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new, params: {tender_line: tender_line_hash}
      end

      it "assigns a tender_line new" do
        expect(assigns(:tender_line).persisted?).to be(false)
      end

      it "assigns customers" do
        expect(assigns(:customers).sort).to eq(
         Customer.all.pluck(:identifier, :id).sort)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end
