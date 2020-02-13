require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe ProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product, name: "product2")}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #show" do

    # TEST as a guest user
    # TEST when a product is asked for showing
    # TEST then the product is assigned
    # TEST then the product's show page is rendered
    describe "as guest user" do
      before :each do
        get :show, params: {id: product1.to_param}
      end

      it "assigns the product" do
        expect(assigns(:product)).to eq(product1)
      end

      it "returns the product's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged customer
    # TEST when a product is asked for showing
    # TEST then the product is assigned
    # TEST then the product's show page is rendered
    describe "as a logged customer asking for his page" do
      before :each do
        sign_in(customer1)
        get :show, params: {id: product1.to_param}
      end

      it "assigns the product" do
        expect(assigns(:product)).to eq(product1)
      end

      it "returns the product's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged supplier
    # TEST when a product is asked for showing
    # TEST then the product is assigned
    # TEST then the product's show page is rendered
    describe "as a logged supplier asking for his page" do
      before :each do
        sign_in(supplier1)
        get :show, params: {id: product1.to_param}
      end

      it "assigns the product" do
        expect(assigns(:product)).to eq(product1)
      end

      it "returns the product's page" do
        expect(response).to render_template(:show)
      end
    end

    # TEST as a logged broker
    # TEST when a product is asked for showing
    # TEST then the product is assigned
    # TEST then the product's show page is rendered
    describe "as a logged broker asking for a product's page" do
      before :each do
        sign_in(broker1)
        get :show, params: {id: product1.to_param}
      end

      it "assigns the product" do
        expect(assigns(:product)).to eq(product1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
