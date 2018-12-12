require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe SizesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:size1) {create(:size, product_id: product1.id)}
  let!(:size2) {create(:size, product_id: product2.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a size is asked for showing
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :show, params: {id: size1.to_param}
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
    # TEST when a size is asked for showing
    # TEST then the size is assigned
    # TEST then the size's show page is rendered
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: size1.to_param}
      end

      it "assigns the size" do
        expect(assigns(:size)).to eq(size1)
      end

      it "returns the size's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged supplier
    # TEST when a size is asked for showing
    # TEST then the size is assigned
    # TEST then the size's show page is rendered
    describe "as a logged supplier asking for his page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: size1.to_param}
      end

      it "assigns the size" do
        expect(assigns(:size)).to eq(size1)
      end

      it "returns the size's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when a size is asked for showing
    # TEST then the size is assigned
    # TEST then the size's show page is rendered
    describe "as a logged broker asking for a size's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: size1.to_param}
      end

      it "assigns the size" do
        expect(assigns(:size)).to eq(size1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
