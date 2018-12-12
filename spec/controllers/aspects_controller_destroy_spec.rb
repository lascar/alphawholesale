require 'rails_helper'

RSpec.describe AspectsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:aspect1) {create(:aspect, product_id: product1.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "DELETE #destroy" do

    # TEST as a guest user
    # TEST when a aspect is asked for destroying
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    # TEST and the aspect is not destroyed
    describe "as guest user" do
      before :each do
        delete :destroy, params: {id: aspect1.to_param}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "does not destroy the aspect" do
        expect(Aspect.find_by_id(aspect1.id)).to eq(aspect1)
      end
    end

    # TEST as a logged customer
    # TEST when a aspect is asked for destroying
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the aspect is not destroyed
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        delete :destroy, params: {id: aspect1.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the aspect" do
        expect(Aspect.find_by_id(aspect1.id)).to eq(aspect1)
      end
    end

    # TEST as a logged supplier
    # TEST when a aspect is asked for destroying
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    # TEST and the aspect is not destroyed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        delete :destroy, params: {id: aspect1.to_param}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

      it "does not destroy the aspect" do
        expect(Aspect.find_by_id(aspect1.id)).to eq(aspect1)
      end
    end

    # TEST as a logged broker
    # TEST when a aspect is asked for destroying
    # TEST then the list of aspects is returned
    # TEST and a message of success in destroying is send
    # TEST and the aspect is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {id: aspect1.to_param}
      end

      it "returns the list of aspects" do
        expect(response.redirect_url).to eq(
         "http://test.host/aspects")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.aspects.successfully_destroyed'))
      end

      it "destroys the aspect" do
        expect(Aspect.find_by_id(aspect1.id)).to be(nil)
      end
    end
  end

end
