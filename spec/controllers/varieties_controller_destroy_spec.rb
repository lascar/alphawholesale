require 'rails_helper'

RSpec.describe VarietiesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:variety1) {create(:variety, product_id: product1.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when a variety is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the variety is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: variety1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "does not destroy the variety" do
        expect(Variety.find_by_id(variety1.id)).to eq(variety1)
      end
    end

    # TEST as a logged customer
    # TEST when a variety is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the variety is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: variety1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the variety" do
        expect(Variety.find_by_id(variety1.id)).to eq(variety1)
      end
    end

    # TEST as a logged supplier
    # TEST when a variety is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the variety is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: variety1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the variety" do
        expect(Variety.find_by_id(variety1.id)).to eq(variety1)
      end
    end

    # TEST as a logged broker
    # TEST when a variety is asked for destroying
    # TEST then the list of varieties is returned
    # TEST and a message of success in destroying is send
    # TEST and the variety is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: variety1.to_param}
      end

      it "returns the list of varieties" do
        expect(response.redirect_url).to eq(
         "http://test.host/varieties")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.varieties.successfully_destroyed'))
      end

      it "destroys the variety" do
        expect(Variety.find_by_id(variety1.id)).to be(nil)
      end
    end
  end

end
