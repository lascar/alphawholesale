require 'rails_helper'

RSpec.describe AspectsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:aspect1) {create(:aspect, product_id: product1.id)}
  let!(:aspect2) {create(:aspect, product_id: product2.id)}
  let(:aspect_hash) {{name: "aspect", product_id: product1.id}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when aspect is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {aspect: aspect_hash}
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
    # TEST when aspect is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        post :create, params: {aspect: aspect_hash}
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
    # TEST when aspect is asked for creating
    # TEST then the newly created aspect is assigned
    # TEST and the supplier owns the aspect
    # TEST and the approved is false
    # TEST and it's redirected to the newly created aspect's page
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {aspect: aspect_hash}
      end

      it "assigns a new aspect" do
        expect(assigns(:aspect).persisted?).to be(true)
      end

      it "attributes the newly created aspect to the supplier" do
        expect(assigns(:aspect).supplier_id).to be(supplier1.id)
      end

      it "has the approved to false" do
        expect(assigns(:aspect).approved).to be(false)
      end

      it "redirect to the newly created aspect" do
        aspect_id = assigns(:aspect).id.to_s
        expect(response.redirect_url).to eq("http://test.host/suppliers/" +
                                      supplier1.id.to_s +
                                      "/aspects/" + aspect_id)
      end
    end

    # TEST as a logged broker
    # TEST when aspect is asked for creating
    # TEST then a create aspect is assigned
    # TEST and the approved is false
    # TEST and the aspect's create page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {aspect: aspect_hash}
      end

      it "assigns a new aspect" do
        expect(assigns(:aspect).persisted?).to be(true)
      end

      it "has the approved to true" do
        expect(assigns(:aspect).approved).to be(false)
      end

      it "redirect to the newly created aspect" do
        aspect_id = assigns(:aspect).id.to_s
        expect(response.redirect_url).to eq("http://test.host/aspects/" +
                                      aspect_id)
      end
    end
  end
end
