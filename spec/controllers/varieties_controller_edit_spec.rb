require 'rails_helper'

RSpec.describe VarietiesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:variety1) {create(:variety, product_id: product1.id)}
  let!(:variety2) {create(:variety, product_id: product2.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #edit" do

    # TEST as a guest user
    # TEST when a variety is asked for edit
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :edit, params: {id: variety1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.variety.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a variety is asked for edit
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {id: variety1.to_param}
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
    # TEST when a variety is asked for edit that is not owned
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :edit, params: {id: variety1.to_param}
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
    # TEST when a variety that he owns is asked for edit
    # TEST then the asked variety is assigned
    # TEST then the variety's edit page is rendered
    describe "as a logged broker" do
      before :each do
        variety1.supplier = supplier1
        variety1.save
        sign_in(supplier1)
        get :edit, params: {id: variety1.to_param}
      end

      it "assigns the variety" do
        expect(assigns(:variety)).to eq(variety1)
      end

      it "render the edit template" do
        expect(response).to render_template(:edit)
      end
    end

    # TEST as a logged broker
    # TEST when a variety is asked for edit
    # TEST then the asked variety is assigned
    # TEST then the variety's edit page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :edit, params: {id: variety1.to_param}
      end

      it "assigns the variety" do
        expect(assigns(:variety)).to eq(variety1)
      end

      it "render the edit template" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
