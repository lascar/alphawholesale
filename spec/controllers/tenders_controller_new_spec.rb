require 'rails_helper'

RSpec.describe TendersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:tender1) {create(:tender, customer: customer1)}
  let!(:tender2) {create(:tender, customer: customer2)}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when tender is asked for new
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :new
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
    # TEST when tender is asked for new
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

    # TEST as a logged customer
    # TEST when tender is asked for new
    # TEST then a new tender is assigned
    # TEST and the new tender's customer is the customer
    # TEST and the tender's new page is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new
      end

      it "assigns a tender new" do
        expect(assigns(:tender).persisted?).to be(false)
      end

      it "puts the customer as the new tender's customer" do
        expect(assigns(:tender).customer_id).to be(customer1.id)
      end

      it "does not assign customers" do
        expect(assigns(:customers)).to be(nil)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end

    # TEST as a logged broker
    # TEST when tender is asked for new
    # TEST then a new tender is assigned
    # TEST and customers is assigned
    # TEST and the tender's new page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new
      end

      it "assigns a tender new" do
        expect(assigns(:tender).persisted?).to be(false)
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
