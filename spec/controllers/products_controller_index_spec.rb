require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  let!(:product1) {create(:product)}
  let!(:product2) {create(:product, name: "product2")}
  let(:product_hash) {{name: "product3"}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}
  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of products is asked for
    # TEST then all the products are assigned
    # TEST and it renders the index
    describe "as guest user" do
      before :each do
        get :index
      end

      it "assigns all products" do
        expect(assigns(:products).sort).to eq(Product.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged customer
    # TEST when the list of products is asked for
    # TEST then all the products are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index
      end

      it "assigns all products" do
        expect(assigns(:products).sort).to eq(Product.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of products is asked for
    # TEST then all the products are assigned
    # TEST and it renders the index
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :index
      end

      it "assigns all products" do
        expect(assigns(:products).sort).to eq(Product.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged broker
    # TEST when the list of products is asked for
    # TEST then all the products are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :index
      end

      it "assigns all products" do
        expect(assigns(:products).sort).to eq(Product.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end
  end
end
