require 'rails_helper'

RSpec.describe VarietiesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:variety1) {create(:variety, product_id: product1.id)}
  let!(:variety2) {create(:variety, product_id: product2.id)}
  let(:variety_hash) {{name: "name",
                         product_id: product1.id}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when variety is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {variety: variety_hash}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when variety is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        post :create, params: {variety: variety_hash}
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
    # TEST when variety is asked for creating
    # TEST then the newly created variety is assigned
    # TEST and the supplier owns the variety
    # TEST and the approved is false
    # TEST and it's redirected to the newly created variety's page
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {variety: variety_hash}
      end

      it "assigns a new variety" do
        expect(assigns(:variety).persisted?).to be(true)
      end

      it "attributes the newly created variety to the supplier" do
        expect(assigns(:variety).supplier_id).to be(supplier1.id)
      end

      it "has the approved to false" do
        expect(assigns(:variety).approved).to be(false)
      end

      it "redirect to the newly created variety" do
        variety_id = assigns(:variety).id.to_s
        expect(response.redirect_url).to eq("http://test.host/suppliers/" +
                                      supplier1.id.to_s +
                                      "/varieties/" + variety_id)
      end
    end

    # TEST as a logged broker
    # TEST when variety is asked for creating
    # TEST then a create variety is assigned
    # TEST and the approved is false
    # TEST and the variety's create page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {variety: variety_hash}
      end

      it "assigns a new variety" do
        expect(assigns(:variety).persisted?).to be(true)
      end

      it "has the approved to true" do
        expect(assigns(:variety).approved).to be(false)
      end

      it "redirect to the newly created variety" do
        variety_id = assigns(:variety).id.to_s
        expect(response.redirect_url).to eq("http://test.host/varieties/" +
                                      variety_id)
      end
    end
  end
end
