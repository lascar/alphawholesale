require 'rails_helper'

RSpec.describe "Offers Feature", type: :feature do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:broker1) {create(:broker)}
  let(:supplier1) {create(:supplier)}
  let!(:attached_product) {create(:attached_product, suppliers: [supplier1], product: product1)}
  let!(:supplier2) {create(:supplier)}

  describe "GET #new" do

    # TEST as a logged supplier with product1 attached
    # TEST when offer is asked for new
    # TEST then a form is rendered with supplier in action as attribute
    # TEST and method post also attribute
    # TEST and a field with the product id as value
    describe "as a logged supplier with 1 product attached" do
      before :each do
        sign_in(supplier1)
        visit new_supplier_offer_url(supplier1)
      end

      xit "puts the supplier as the new offer's supplier and the product in field" do
        expect(page).to have_xpath("//form[@action='/suppliers/" +
                                   supplier1.id.to_s + "/offers'
                                   and @method='post']")
        expect(page).to have_field("offer[product_id]", with: product1.id)
      end
    end

    # TEST as a logged broker
    # TEST when offer is asked for new
    # TEST then a form is rendered
    # TEST and method post also attribute
    # TEST and all suppliers as option for selecting
    # TEST and fields with all the products id as value
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit new_offer_url
      end

      xit "assigns a offer new" do
        expect(page).to have_xpath("//form[@action='/offers' and @method='post']")
        expect(page).to have_field("offer[product_id]", with: product1.id)
        expect(page).to have_field("offer[product_id]", with: product2.id)
      end
    end
  end
end
