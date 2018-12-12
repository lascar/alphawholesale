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

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when packaging is asked for updating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        put :update, params: {id: packaging1.to_param,
                              packaging: packaging_hash}
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
    # TEST when a packaging is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        put :update, params: {id: packaging1.to_param, packaging: packaging_hash}
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
    # TEST when a packaging not owned by the supplier is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {id: packaging1.to_param, packaging: packaging_hash}
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

    # TEST as a logged supplier
    # TEST when a packaging owned by the supplier is asked for updating
    # TEST then a update packaging is assigned
    # TEST then the packaging's update page is rendered
    describe "as a logged supplier" do
      before :each do
        packaging1.supplier = supplier1
        packaging1.save
        sign_in(supplier1)
        put :update, params: {id: packaging1.to_param, packaging: packaging_hash}
      end

      it "changes the packaging" do
        expect(assigns(:packaging).name).to eq(packaging_hash[:name])
      end

      it "redirect to the newly updated packaging" do
        expect(response.redirect_url).to eq("http://test.host/packagings/" +
                                            packaging1.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when a packaging is asked for updating
    # TEST then a update packaging is assigned
    # TEST then the packaging's update page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {id: packaging1.to_param, packaging: packaging_hash}
      end

      it "changes the packaging" do
        expect(assigns(:packaging).name).to eq(packaging_hash[:name])
      end

      it "redirect to the newly updated packaging" do
        expect(response.redirect_url).to eq("http://test.host/packagings/" +
                                            packaging1.id.to_s)
      end
    end
  end
end
