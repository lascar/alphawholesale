require 'rails_helper'

# a supplier can have somme products attached
# these products appears in a list of attached products for this supplier
RSpec.describe 'Suppliers Feature new', type: :feature do
  let!(:product1) {create(:product, approved: true)}
  let!(:product2) {create(:product, approved: true)}
  let!(:product3) {create(:product, approved: true)}
  let!(:product4) {create(:product, approved: true)}
  let!(:broker1) {create(:broker, products: [product1, product2, product3])}
  let(:supplier1) {create(:supplier, products: [product1])}

  describe 'GET #attach_products' do

    # TEST as a supplier
    # TEST when a list of product available is asked to be attached
    # TEST then a list of the attached product can be displayed
    describe 'as a supplier' do
      before :each do
        sign_in(supplier1)
      end

      it 'assigns a new supplier' do
        visit supplier_path(supplier1)
        find('#attached_products').click
        expect(page).to have_content(product1.name.capitalize)
        find(:xpath, "//a[@href='#{edit_attached_products_path}']").click
        expect(page).to have_xpath("//form[@action='/attached_products'
                                   and @method='post']")
        attachable_product1 = AttachedProduct.where(product_id: product1.id,
                                                    attachable_id: broker1.id,
                                                    attachable_type: 'Broker').first
        attachable_product2 = AttachedProduct.where(product_id: product2.id,
                                                    attachable_id: broker1.id,
                                                    attachable_type: 'Broker').first
        expect(page.find("input#attached_product_" + attachable_product1.id.to_s)).
          to be_checked
        expect(page).not_to have_content(product4.name.capitalize)
        find('input#attached_product_' + attachable_product2.id.to_s).check
        find('[name=commit]').click
        expect(page.current_url).to eq(
          'http://www.example.com/attached_products')
        attached_product1 = AttachedProduct.where(product_id: product1.id,
                                                  attachable_id: supplier1.id,
                                                  attachable_type: 'Supplier').first
        attached_product2 = AttachedProduct.where(product_id: product2.id,
                                                  attachable_id: supplier1.id,
                                                  attachable_type: 'Supplier').first
        expect(page).to have_selector("tr#attached_product_#{attached_product1.id.to_s}")
        expect(page).to have_selector("tr#attached_product_#{attached_product2.id.to_s}")
        expect(page).to have_content(
          I18n.t('controllers.attached_products.update.succefully'))
      end
    end

  end
end
