require 'rails_helper'

RSpec.describe AttachedProductsController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:variety1) {product1.varieties.first}
  let!(:aspect1) {product1.aspects.first}
  let(:attached_product_hash) {{definition:{product: product1.name,
                                            variety: variety1,
                                            aspect: aspect1 }}}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "POST #create" do

    # TEST as a guest user
    # TEST when attached_product is asked for creating
    # TEST then it is routed to routing error
    it "does not routes post /attached_products to attached_products#create" do
      expect(:post => "/attached_products/").to route_to(controller: 'welcome',
                                                         action: 'routing_error',
                                                         url: 'attached_products')
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
        expect(response.redirect_url).to eq("http://test.host/customers/#{customer1.id.to_s}/attached_products")
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
        post :create, params: {supplier_id: supplier1.id, attached_product: attached_product_hash}
      end

      it "assigns a new attached product" do
        expect(AttachedProduct.where(attachable: supplier1).count).to eq(@count + 1)
      end

      it "redirect to the newly created aspect" do
        expect(response.redirect_url).to eq("http://test.host/suppliers/#{supplier1.id.to_s}/attached_products")
      end
    end
  end
end
