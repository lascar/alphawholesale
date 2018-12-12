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

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a tender_line is asked for edit
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :edit, params: {id: tender_line1.to_param}
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
    # TEST when a tender_line is asked for edit
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: tender_line1.to_param}
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
    # TEST when tender_line owned by other customer is asked for editing
    # TEST then the customer's page is returned
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: tender_line2.to_param}
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


    # TEST as a logged customer
    # TEST when tender_line owned by the customer is asked for editing
    # TEST then the edited tender_line is assigned
    # TEST and customers is not assigned
    # TEST and the edit template is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: tender_line1.to_param}
      end

      it "assigns a new tender_line" do
        expect(assigns(:tender_line).persisted?).to be(true)
      end

      it "does not assign customers" do
        expect(assigns(:customers)).to be(nil)
      end

      it "redirect to the newly created tender_line" do
        expect(response).to render_template(:edit)
      end
    end

    # TEST as a logged broker
    # TEST when a tender_line is asked for edit
    # TEST then the asked tender_line is assigned
    # TEST and customers is assigned
    # TEST then the tender_line's edit page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: tender_line1.to_param}
      end

      it "assigns the tender_line" do
        expect(assigns(:tender_line)).to eq(tender_line1)
      end

      it "assigns customers" do
        expect(assigns(:customers).sort).to eq(
         Customer.all.pluck(:identifier, :id).sort)
      end

      it "render the edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
