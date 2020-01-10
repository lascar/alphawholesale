require 'rails_helper'

# as a broker, I can create a new attached product
# these products appears in a list of attached products for this customer
RSpec.describe 'Admin Attached Products Customers Feature', type: :feature do
  let!(:product1) {create(:product, approved: true)}
  let!(:product2) {create(:product, approved: true)}
  let!(:product3) {create(:product, approved: true)}
  let!(:variety1_product1) {create(:variety, approved: true, product: product1)}
  let!(:variety2_product1) {create(:variety, approved: true, product: product1)}
  let!(:variety3_product1) {create(:variety, approved: true, product: product1)}
  let!(:aspect1_product1) {create(:aspect, approved: true, product: product1)}
  let!(:aspect2_product1) {create(:aspect, approved: true, product: product1)}
  let!(:aspect3_product1) {create(:aspect, approved: true, product: product1)}
  let!(:packaging1_product1) {create(:packaging, approved: true, product: product1)}
  let!(:packaging2_product1) {create(:packaging, approved: true, product: product1)}
  let!(:packaging3_product1) {create(:packaging, approved: true, product: product1)}
  let!(:variety1_product2) {create(:variety, approved: true, product: product2)}
  let!(:variety2_product2) {create(:variety, approved: true, product: product2)}
  let!(:variety3_product2) {create(:variety, approved: true, product: product2)}
  let!(:aspect1_product2) {create(:aspect, approved: true, product: product2)}
  let!(:aspect2_product2) {create(:aspect, approved: true, product: product2)}
  let!(:aspect3_product2) {create(:aspect, approved: true, product: product2)}
  let!(:packaging1_product2) {create(:packaging, approved: true, product: product2)}
  let!(:packaging2_product2) {create(:packaging, approved: true, product: product2)}
  let!(:packaging3_product2) {create(:packaging, approved: true, product: product2)}
  let!(:broker1) {create(:broker)}
  let!(:attached_product1) {create(:attached_product, attachable: broker1,
                                   product: product1, variety: variety1_product1,
                                   aspect: aspect1_product1, packaging: packaging1_product1)}
  let!(:attached_product2) {create(:attached_product, attachable: broker1,
                                   product: product2, variety: variety1_product2,
                                   aspect: aspect1_product2, packaging: packaging1_product2)}

  describe 'POST #attach_products' do

    # TEST as a broker
    # TEST when I ask for a new product
    # TEST then a list of checkbox is proposed
    # TEST and I can create up that list attached product for broker
    describe 'as a broker' do
      before :each do
        sign_in(broker1)
      end

      it 'asks for a list of attached products to customers' do
        # new
        visit new_admin_attached_products_path
        expect(page).to have_xpath("//form[@action='/admin_attached_products'
                                   and @method='post']")
        check product1.name
        check variety2_product1.name
        check aspect1_product1.name
        check packaging1_product1.name
        click_button I18n.t("views.create")

        # edit
        attached_product1_id = "update_attached_products_#{product1.id.to_s + "_" +
         variety1_product1.id.to_s + "_" + aspect1_product1.id.to_s + "_" +
         packaging1_product1.id.to_s}"
        expect(find('#' + attached_product1_id).checked?).to be(true)
        attached_product1_id = "update_attached_products_#{product2.id.to_s + "_" +
         variety1_product2.id.to_s + "_" + aspect1_product2.id.to_s + "_" +
         packaging1_product2.id.to_s}"
        expect(find('#' + attached_product1_id).checked?).to be(true)
        attached_product1_id = "update_attached_products_#{product1.id.to_s + "_" +
         variety2_product1.id.to_s + "_" + aspect1_product1.id.to_s + "_" +
         packaging1_product1.id.to_s}"
        find('#' + attached_product1_id).check
        click_button I18n.t("views.update")

        # index
        attached_products = AttachedProduct.where(attachable_type: 'Broker')
        expect(attached_products.count).to eq(3)
        expect(page.assert_selector("tr#attached_product_#{attached_products[2][:id].to_s}")).to be(true)
        within("tr#attached_product_#{attached_products[2][:id].to_s}") do
          find("td", :text => "#{product1.name}")
          find("td", :text => "#{variety2_product1.name}")
          find("td", :text => "#{aspect1_product1.name}")
          find("td", :text => "#{packaging1_product1.name}")
        end
      end
    end

  end
end
