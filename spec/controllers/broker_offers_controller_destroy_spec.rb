require 'rails_helper'

RSpec.describe BrokerOffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, supplier_id: supplier1.id)}
  let!(:offer2) {create(:offer, supplier_id: supplier2.id)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when an offer is asked for destroying
    # TEST then 404 is returned
    describe "as guest user" do
			it "does not routes delete brokers/1/offers/1 to offers#destroy" do
        expect{ delete :destroy, params: {broker_id: broker1.id, offer_id: offer1.id} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged broker
    # TEST when a offer  is asked for destroying
    # TEST then the list of offers is returned
    # TEST and a message of success in destroying is send
    # TEST and the offer is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {broker_id: broker1.id, id: offer1.to_param}
      end

      it "returns the list of offers" do
        expect(response.redirect_url).to eq("http://test.host/brokers/#{broker1.id.to_s}/offers/")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.offers.successfully_destroyed'))
      end

      it "destroys the offer" do
        expect(Offer.find_by_id(offer1.id)).to be(nil)
      end
    end
  end
end
