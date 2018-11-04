require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier, identifier: "supplier2", email: "supplier2@test.com")}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when supplier is asked for new
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :new
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authenticated message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.supplier.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when supplier is asked for new
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new
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
    # TEST when supplier is asked for new
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :new
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
    # TEST when supplier is asked for new
    # TEST then a new supplier is assigned
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new
      end

      it "assigns a new supplier" do
        expect(assigns(:supplier).persisted?).to be(false)
      end
    end
  end
end
