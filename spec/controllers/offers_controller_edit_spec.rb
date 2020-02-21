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
    # TEST when offer is asked for editing
    # TEST then 404 is returned
    describe "as guest user" do
			it "does not routes get /offers/1/edit to offers#edit" do
        expect{ get :edit, params: {offer_id: offer1.id} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged customer
    # TEST when offer is asked for editing
    # TEST then 404 is returned
    describe "as customer" do
			it "does not routes get /customers/1/offers/1/edit to offers#edit" do
        sign_in(customer1)
        expect{ get :edit, params: {customer_id: customer1.id, offer_id: offer1.id} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged supplier
    # TEST when offer owned by other supplier is asked for editing
    # TEST then the customer's page is returned
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {supplier_id: supplier1.id, id: offer2.to_param}
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
