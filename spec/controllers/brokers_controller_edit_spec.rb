require 'rails_helper'

RSpec.describe BrokersController, type: :controller do
  let!(:broker1) {create(:broker)}
  let!(:broker2) {create(:broker, identifier: "broker2",
                                  email: "broker2@test.com")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a broker is asked for editing
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user asking for a broker's editing page" do
      before :each do
        get :edit, params: {id: broker1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a broker is asked for editing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for a broker's editing page" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: broker1.to_param}
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
    # TEST when a broker is asked for editing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for
     an other broker's editing page" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: broker1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        get :edit, params: {id: broker1.to_param}
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged broker
    # TEST when a broker is asked his page for editing
    # TEST then the broker is assigned
    # TEST and it's rendered the edit template
    describe "as a logged broker asking for his editing page" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: broker1.to_param}
      end

      it "assigns the broker" do
        expect(assigns(:broker)).to eq(broker1)
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end
    end

    # TEST as a logged broker
    # TEST when an other broker page for editing is asked
    # TEST then the asked broker is assigned
    # TEST and it's rendered the edit template
    describe "as a logged broker asking for new broker page" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: broker2.to_param}
      end

      it "returns the broker's page" do
        expect(assigns(:broker)).to eq(broker2)
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
