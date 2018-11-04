require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe TendersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:tender1) {create(:tender, customer: customer1)}
  let!(:tender2) {create(:tender, customer: customer2)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a tender is asked for showing
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: tender1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.tender.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a tender is asked for showing
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: tender1.to_param}
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
    # TEST when an other's customer tender is asked for showing
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer2)
        get :show, params: {id: tender1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer2.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when an tender owned by this customer is asked for showing
    # TEST then the tender is assigned
    # TEST then the tender's tender lines are assigned
    # TEST and the tender's show page is rendered
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: tender1.to_param}
      end

      it "assigns the tender" do
        expect(assigns(:tender)).to eq(tender1)
      end

      it "assigns the tender's tender lines" do
        expect(assigns(:tender_lines).sort).to eq(tender1.tender_lines.sort)
      end

      it "returns the tender's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when a tender is asked for showing
    # TEST then the tender is assigned
    # TEST then the tender's show page is rendered
    describe "as a logged broker asking for a tender's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: tender1.to_param}
      end

      it "assigns the tender" do
        expect(assigns(:tender)).to eq(tender1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
