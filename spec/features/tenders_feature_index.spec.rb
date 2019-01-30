require 'rails_helper'

RSpec.describe "Tenders Feature", type: :feature do

  let!(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer)}
  let!(:supplier1) {create(:supplier)}
  let!(:broker1) {create(:broker)}
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  # tender1 is approved and have 2 lines of product1 and 1 line of product2
  # tender1 is owned by customer1
  let!(:tender1) {create(:tender, approved: true, customer_id: customer1.id)}
  let!(:tender_line1) {create(:tender_line, tender_id: tender1.id,
                              product_id: product1.id)}
  let!(:tender_line2) {create(:tender_line, tender_id: tender1.id,
                              product_id: product1.id)}
  let!(:tender_line3) {create(:tender_line, tender_id: tender1.id,
                              product_id: product2.id)}
  # tender2 is approved and have 2 lines of product1 and 1 line of product2
  # tender2 is owned by customer2
  let!(:tender2) {create(:tender, approved: true, customer_id: customer2.id)}
  let!(:tender_line4) {create(:tender_line, tender_id: tender2.id,
                               product_id: product1.id)}
  let!(:tender_line5) {create(:tender_line, tender_id: tender2.id,
                              product_id: product1.id)}
  let!(:tender_line6) {create(:tender_line, tender_id: tender2.id,
                              product_id: product2.id)}
  # tender3 is not approved and have 2 lines of product1 and 1 line of product2
  # tender2 is owned by customer1
  let!(:tender3) {create(:tender, approved: false, customer_id: customer1.id)}
  let!(:tender_line7) {create(:tender_line, tender_id: tender3.id,
                              product_id: product1.id)}
  let!(:tender_line8) {create(:tender_line, tender_id: tender3.id,
                              product_id: product1.id)}
  let!(:tender_line9) {create(:tender_line, tender_id: tender3.id,
                              product_id: product2.id)}

  describe "GET #index" do
    # TEST as a supplier
    # TEST when the list of tenders is asked for
    # TEST then all the approved tenders are listed that have in it
    # TEST an to him attached product
    # TEST and the quantity total of each product are displayed
    describe "as a logged supplier" do
      before :each do
        supplier1.products = [product1]
        sign_in(supplier1)
        visit supplier_tenders_path(supplier1)
      end

      it "presentes only approved tenders that are product attached to the supplier" do
        total_product1 = tender_line1.unit + tender_line2.unit +
                         tender_line4.unit + tender_line5.unit
        expect(page).to have_content(I18n.t('activerecord.models.attributes.
                                             product.name') + ' : ' +
                                    total_product1.to_s + tender1.currency)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of tenders is asked for
    # TEST then all the tenders that belong to the supplier are presented
    describe "as a logged supplier" do
      before :each do
        tender1.supplier = supplier1
        tender1.save
        tender3.supplier = supplier1
        tender3.save
        sign_in(supplier1)
        visit supplier_tenders_url(supplier1)
      end

      it "presentes only approved tenders that are product attached to the supplier" do
        expect(page).to have_content("0.1")
        expect(page).to have_no_content("0.2")
        expect(page).to have_no_content("0.3")
        expect(page).to have_no_content("0.4")
        expect(page).to have_content("0.5")
        expect(page).to have_no_content("0.6")
      end
    end

    # TEST as a logged broker
    # TEST when the list of tenders is asked for
    # TEST then all the tenders are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit tenders_url
      end

      it "presentes only approved tenders" do
        expect(page).to have_content("0.1")
        expect(page).to have_content("0.2")
        expect(page).to have_content("0.3")
        expect(page).to have_content("0.4")
        expect(page).to have_no_content("0.5")
        expect(page).to have_no_content("0.6")
      end
    end
  end
end
