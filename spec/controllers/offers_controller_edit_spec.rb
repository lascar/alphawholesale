require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:offer1) {create(:offer, supplier: supplier1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a offer is asked for edit
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :edit, params: {id: offer1.to_param}
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
    # TEST when a offer is asked for edit
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: offer1.to_param}
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
    # TEST when offer owned by other supplier is asked for editing
    # TEST then the customer's page is returned
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: offer2.to_param}
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
  end
end
