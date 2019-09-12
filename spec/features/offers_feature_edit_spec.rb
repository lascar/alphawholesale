require 'rails_helper'

RSpec.describe "Offers Feature", type: :feature do
  let!(:broker1) {create(:broker, products: [product1])}
  let(:product1) {create(:product, approved: true)}
  let(:supplier1) {create(:supplier, products: [product1])}
  let(:supplier2) {create(:supplier)}
  let!(:offer1) {create(:offer, supplier: supplier1, product: product1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}

  describe "GET #edit" do

    # TEST as a logged supplier
    # TEST when offer owned by the supplier is asked for editing
    # TEST then a form to the supplier's offer is presented
    # TEST and the supplier's unit price is edited
    # TEST and the broker's unit price is not edited
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        visit edit_supplier_offer_url(supplier1, id: offer1.to_param)
      end

      it "assigns a new offer" do
        expect(page).to have_xpath(
         "//form[@action='/suppliers/#{supplier1.id.to_s}/offers/#{offer1.id.to_s}']")
        expect(page).to have_xpath("//input[@name='offer[product]' and
                                   @value='#{product1.name}']")
        expect(page).to have_xpath("//input[@name='offer[unit_price_supplier]']")
        expect(page).to have_no_xpath("//input[@name='offer[unit_price_broker]']")
      end
    end

    # TEST as a logged broker
    # TEST when a offer is asked for edit
    # TEST then a form to the offer is presented
    # TEST and the supplier's unit price is edited
    # TEST and the broker's unit price is edited
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit edit_offer_url(id: offer1.to_param)
      end

      it "assigns a new offer" do
        expect(page).to have_xpath(
         "//form[@action='/offers/#{offer1.id.to_s}']")
        expect(page).to have_xpath("//input[@name='offer[product]' and
                                   @value='#{product1.name}']")
        expect(page).to have_xpath("//input[@name='offer[unit_price_supplier]']")
        expect(page).to have_xpath("//input[@name='offer[unit_price_broker]']")
      end
    end
  end
end
