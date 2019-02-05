require 'rails_helper'

RSpec.describe 'Suppliers feature show', type: :feature do
  let(:broker1) {create(:broker)}
  let!(:supplier1) {create(:supplier_with_offers)}
  let!(:supplier2) {create(:supplier_with_offers)}

  # TEST as a logged supplier
  # TEST when the supplier is asked for his page
  # TEST then the supplier is assigned
  # TEST and all the offers of the supplier are assigned
  # TEST and all the products of the supplier are assigned
  # TEST and the supplier's show page is returned
  describe "as a logged supplier asking for his page" do
    before :each do
      sign_in(supplier1)
      visit supplier_url(supplier1)
    end

    it "has a link edit for the supplier and
     shows the last supplier's offer price" do
      expect(page).to have_link ({href:
                                  "/suppliers/" + supplier1.id.to_s + "/edit"})
      expect(page).to have_content (
       supplier1.offers.last.unit_price_supplier.to_s)
    end
  end

  # TEST as a logged broker
  # TEST when a supplier is asked for show
  # TEST then the supplier is assigned
  # TEST and all the offers of the supplier are assigned
  # TEST and all the products of the supplier are assigned
  # TEST and the supplier's show page is returned
  describe "as a logged broker asking for a supplier's page" do
    before :each do
      sign_in(broker1)
      visit supplier_url(supplier1)
    end

    it "assigns the supplier and has a link edit for the supplier and
      shows the last supplier's offer price" do
      expect(page).to have_content (supplier1.identifier)
      expect(page).to have_link ({href:
                                  "/suppliers/" + supplier1.id.to_s + "/edit"})
      expect(page).to have_content (
       supplier1.offers.last.unit_price_supplier.to_s)
    end
  end
end

