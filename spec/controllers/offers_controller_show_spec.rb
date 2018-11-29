require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, supplier: supplier1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a offer is asked for showing
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: offer1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.offer.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when an other's supplier offer is asked for showing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(supplier2)
        get :show, params: {id: offer1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier2.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end
  end
end
