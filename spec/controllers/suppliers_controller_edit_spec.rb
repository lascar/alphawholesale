require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier, identifier: "supplier2",
                                      email: "supplier2@test.com")}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a supplier is asked for editing
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user asking for a supplier's editing page" do

      before :each do
        get :edit, params: {id: supplier1.to_param}
      end

      it "returns the root page and returns a non authorized message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for editing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for a supplier's editing page" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: supplier1.to_param}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when an other supplier is asked for editing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for
     an other supplier's editing page" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: supplier2.to_param}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when a supplier is asked his page for editing
    # TEST then the supplier's page is returned
    describe "as a logged supplier asking for his editing page" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: supplier1.to_param}
      end

      it "assigns the asked supplier" do
        expect(assigns(:supplier)).to eq(supplier1)
      end
    end

    # TEST as a logged broker
    # TEST when a supplier page for editing is asked
    # TEST then the asked supplier is assigned
    describe "as a logged broker asking for new supplier page" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: supplier1.to_param}
      end

      it "assigns the asked supplier" do
        expect(assigns(:supplier)).to eq(supplier1)
      end
    end
  end
end
