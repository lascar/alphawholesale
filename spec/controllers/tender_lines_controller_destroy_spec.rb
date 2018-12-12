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
  let!(:tender2) {create(:tender, customer: customer2,
                         date_start: date, date_end: date + 1.months)}
  let!(:tender_line1) {create(:tender_line, tender: tender1, product: product1,
                              unit: 1, unit_price: 2.09)}
  let!(:tender_line2) {create(:tender_line, tender: tender2, product: product1,
                              unit: 1, unit_price: 2.09)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when an tender_line is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the tender_line is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: tender_line1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "does not destroy the tender_line" do
        expect(TenderLine.find_by_id(tender_line1.id)).to eq(tender_line1)
      end
    end

    # TEST as a logged supplier
    # TEST when a tender_line is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the tender_line is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: tender_line1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the tender_line" do
        expect(TenderLine.find_by_id(tender_line1.id)).to eq(tender_line1)
      end
    end

    # TEST as a logged customer
    # TEST when a tender_line that not belongs to the customer is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the tender_line is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: tender_line2.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the tender_line" do
        expect(TenderLine.find_by_id(tender_line1.id)).to eq(tender_line1)
      end
    end

    # TEST as a logged customer
    # TEST when a tender_line that belongs to the customer is asked for destroying
    # TEST then the list of tender_lines is returned
    # TEST and a message of success in destroying is send
    # TEST and the tender_line is destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: tender_line1.to_param}
      end

      it "returns the list of the customer's tender_lines" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s + "/tender_lines")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.tender_lines.successfully_destroyed'))
      end

      it "destroys the tender_line" do
        expect(TenderLine.find_by_id(tender_line1.id)).to be(nil)
      end
    end


    # TEST as a logged broker
    # TEST when a tender_line  is asked for destroying
    # TEST then the list of tender_lines is returned
    # TEST and a message of success in destroying is send
    # TEST and the tender_line is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: tender_line1.to_param}
      end

      it "returns the list of tender_lines" do
        expect(response.redirect_url).to eq("http://test.host/tender_lines")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.tender_lines.successfully_destroyed'))
      end

      it "destroys the tender_line" do
        expect(TenderLine.find_by_id(tender_line1.id)).to be(nil)
      end
    end
  end
end
