require 'rails_helper'

RSpec.describe SizesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:size1) {create(:size, product_id: product1.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when a size is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the size is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: size1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "does not destroy the size" do
        expect(Size.find_by_id(size1.id)).to eq(size1)
      end
    end

    # TEST as a logged customer
    # TEST when a size is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the size is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: size1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the size" do
        expect(Size.find_by_id(size1.id)).to eq(size1)
      end
    end

    # TEST as a logged supplier
    # TEST when a size is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the size is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: size1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the size" do
        expect(Size.find_by_id(size1.id)).to eq(size1)
      end
    end

    # TEST as a logged broker
    # TEST when a size is asked for destroying
    # TEST then the list of sizes is returned
    # TEST and a message of success in destroying is send
    # TEST and the size is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: size1.to_param}
      end

      it "returns the list of sizes" do
        expect(response.redirect_url).to eq(
         "http://test.host/sizes")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.sizes.successfully_destroyed'))
      end

      it "destroys the size" do
        expect(Size.find_by_id(size1.id)).to be(nil)
      end
    end
  end

end
