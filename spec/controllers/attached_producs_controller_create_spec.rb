require 'rails_helper'

RSpec.describe AttachedProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:variety1) {create(:variety, product_id: product1.id)}
  let!(:aspect1) {create(:aspect, product_id: product1.id)}
  let(:attached_product_hash) {{definition:{product: product1.name,
                                            variety: variety1.name,
                                            aspect: aspect1.name }}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when an attached product is asked for creating
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        post :create, params: {attached_product: attached_product_hash}
      end

      it "returns 302 status" do
        expect(response.status).to eq(302)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end

      it "redirect to the root page" do
        expect(response.redirect_url).to match("http://test.host/")
      end

    end


    # TEST as a logged customer
    # TEST when an attached product is asked for creating
    # TEST then a create aspect is created
    # TEST and the aspect's create page is rendered
    describe "as a logged customer" do
      before :each do
        @count = AttachedProduct.where(attachable: customer1).count
        sign_in(customer1)
        post :create, params: {customer_id: customer1.id, attached_product: attached_product_hash}
      end

      it "assigns a new attached product" do
        expect(AttachedProduct.where(attachable: customer1).count).to eq(@count + 1)
      end

      it "redirect to the newly created aspect" do
        expect(response.redirect_url).to eq("http://test.host/attached_products")
      end
    end

    # TEST as a logged supplier
    # TEST when an attached product is asked for creating
    # TEST then a create aspect is created
    # TEST and the aspect's create page is rendered
    describe "as a logged supplier" do
      before :each do
        @count = AttachedProduct.where(attachable: supplier1).count
        sign_in(supplier1)
        post :create, params: {attached_product: attached_product_hash}
      end

      it "assigns a new attached product" do
        expect(AttachedProduct.where(attachable: supplier1).count).to eq(@count + 1)
      end

      it "redirect to the newly created aspect" do
        expect(response.redirect_url).to eq("http://test.host/attached_products")
      end
    end

    # TEST as a logged broker
    # TEST when an attached product is asked for creating
    # TEST then a create aspect is created
    # TEST and the aspect's create page is rendered
    describe "as a logged broker" do
      before :each do
        @count = AttachedProduct.where(attachable: broker1).count
        sign_in(broker1)
        post :create, params: {attached_product: attached_product_hash}
      end

      it "assigns a new attached product" do
        expect(AttachedProduct.where(attachable: broker1).count).to eq(@count + 1)
      end

      it "redirect to the newly created aspect" do
        expect(response.redirect_url).to eq("http://test.host/attached_products")
      end
    end
  end
end
