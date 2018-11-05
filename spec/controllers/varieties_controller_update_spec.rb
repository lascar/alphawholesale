require 'rails_helper'

RSpec.describe VarietiesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:variety1) {create(:variety, product_id: product1.id)}
  let!(:variety1) {create(:variety, product_id: product1.id)}
  let!(:variety3) {create(:variety, product_id: product1.id)}
  let(:variety_hash) {{name: "name",
                         product_id: product1.id}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when variety is asked for updating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        put :update, params: {id: variety1.to_param,
                              variety: variety_hash}
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
    # TEST when a variety is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        put :update, params: {id: variety1.to_param, variety: variety_hash}
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
    # TEST when a variety not owned by the supplier is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {id: variety1.to_param, variety: variety_hash}
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
    # TEST when a variety owned by the supplier is asked for updating
    # TEST then a update variety is assigned
    # TEST then the variety's update page is rendered
    describe "as a logged supplier" do
      before :each do
        variety1.supplier = supplier1
        variety1.save
        sign_in(supplier1)
        put :update, params: {id: variety1.to_param, variety: variety_hash}
      end

      it "changes the variety" do
        expect(assigns(:variety).name).to eq(variety_hash[:name])
      end

      it "redirect to the newly updated variety" do
        expect(response.redirect_url).to eq("http://test.host/varieties/" +
                                            variety1.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when a variety is asked for updating
    # TEST then a update variety is assigned
    # TEST then the variety's update page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {id: variety1.to_param, variety: variety_hash}
      end

      it "changes the variety" do
        expect(assigns(:variety).name).to eq(variety_hash[:name])
      end

      it "redirect to the newly updated variety" do
        expect(response.redirect_url).to eq("http://test.host/varieties/" +
                                            variety1.id.to_s)
      end
    end
  end
end
