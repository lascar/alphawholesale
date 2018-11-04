require 'rails_helper'

RSpec.describe PackagingsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:packaging1) {create(:packaging, product_id: product1.id)}
  let!(:packaging2) {create(:packaging, product_id: product2.id)}
  let(:packaging_hash) {{name: "packaging",
                         product_id: product1.id}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when packaging is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {packaging: packaging_hash}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.packaging.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when packaging is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        post :create, params: {packaging: packaging_hash}
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
    # TEST when packaging is asked for creating
    # TEST then the newly created packaging is assigned
    # TEST and the supplier owns the packaging
    # TEST and the approved is false
    # TEST and it's redirected to the newly created packaging's page
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        post :create, params: {packaging: packaging_hash}
      end

      it "assigns a new packaging" do
        expect(assigns(:packaging).persisted?).to be(true)
      end

      it "attributes the newly created packaging to the supplier" do
        expect(assigns(:packaging).supplier_id).to be(supplier1.id)
      end

      it "has the approved to false" do
        expect(assigns(:packaging).approved).to be(false)
      end

      it "redirect to the newly created packaging" do
        packaging_id = assigns(:packaging).id.to_s
        expect(response.redirect_url).to eq("http://test.host/suppliers/" +
                                      supplier1.id.to_s +
                                      "/packagings/" + packaging_id)
      end
    end

    # TEST as a logged broker
    # TEST when packaging is asked for creating
    # TEST then a create packaging is assigned
    # TEST and the approved is false
    # TEST and the packaging's create page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        post :create, params: {packaging: packaging_hash}
      end

      it "assigns a new packaging" do
        expect(assigns(:packaging).persisted?).to be(true)
      end

      it "has the approved to true" do
        expect(assigns(:packaging).approved).to be(false)
      end

      it "redirect to the newly created packaging" do
        packaging_id = assigns(:packaging).id.to_s
        expect(response.redirect_url).to eq("http://test.host/packagings/" +
                                      packaging_id)
      end
    end
  end
end
