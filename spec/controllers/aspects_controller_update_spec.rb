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

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when aspect is asked for updating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        put :update, params: {id: aspect1.to_param,
                              aspect: aspect_hash}
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
    # TEST when a aspect is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        put :update, params: {id: aspect1.to_param, aspect: aspect_hash}
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
    # TEST when a aspect not owned by the supplier is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        put :update, params: {id: aspect1.to_param, aspect: aspect_hash}
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
    # TEST when a aspect owned by the supplier is asked for updating
    # TEST then a update aspect is assigned
    # TEST then the aspect's update page is rendered
    describe "as a logged supplier" do
      before :each do
        aspect1.supplier = supplier1
        aspect1.save
        sign_in(supplier1)
        put :update, params: {id: aspect1.to_param, aspect: aspect_hash}
      end

      it "changes the aspect" do
        expect(assigns(:aspect).name).to eq(aspect_hash[:name])
      end

      it "redirect to the newly updated aspect" do
        expect(response.redirect_url).to eq("http://test.host/suppliers/" +
                                            supplier1.id.to_s + "/aspects/" +
                                            aspect1.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when a aspect is asked for updating
    # TEST then a update aspect is assigned
    # TEST then the aspect's update page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        put :update, params: {id: aspect1.to_param, aspect: aspect_hash}
      end

      it "changes the aspect" do
        expect(assigns(:aspect).name).to eq(aspect_hash[:name])
      end

      it "redirect to the newly updated aspect" do
        expect(response.redirect_url).to eq("http://test.host/aspects/" +
                                            aspect1.id.to_s)
      end
    end
  end
end
