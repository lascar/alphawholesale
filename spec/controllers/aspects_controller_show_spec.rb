require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe AspectsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:aspect1) {create(:aspect, product_id: product1.id)}
  let!(:aspect2) {create(:aspect, product_id: product2.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a aspect is asked for showing
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: aspect1.to_param}
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
    # TEST when a aspect is asked for showing
    # TEST then the aspect is assigned
    # TEST then the aspect's show page is rendered
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: aspect1.to_param}
      end

      it "assigns the aspect" do
        expect(assigns(:aspect)).to eq(aspect1)
      end

      it "returns the aspect's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged supplier
    # TEST when a aspect is asked for showing
    # TEST then the aspect is assigned
    # TEST then the aspect's show page is rendered
    describe "as a logged supplier asking for his page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: aspect1.to_param}
      end

      it "assigns the aspect" do
        expect(assigns(:aspect)).to eq(aspect1)
      end

      it "returns the aspect's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when a aspect is asked for showing
    # TEST then the aspect is assigned
    # TEST then the aspect's show page is rendered
    describe "as a logged broker asking for a aspect's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: aspect1.to_param}
      end

      it "assigns the aspect" do
        expect(assigns(:aspect)).to eq(aspect1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
