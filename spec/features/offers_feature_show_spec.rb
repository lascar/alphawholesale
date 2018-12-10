require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe "Offers Feature", type: :feature do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, approved: true, unit_price_supplier: 0.1,
                                unit_price_broker: 0.2)}

  describe "GET #show" do

    # TEST as a logged customer
    # TEST when a offer is asked for showing
    # TEST then the unit price broker is presented
    # TEST then the unit price supplier is not presented
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        visit customer_offer_url(id: offer1.id, customer_id: customer1)
      end

      it "presents the broker unit price" do
        expect(page).to have_content(offer1.unit_price_broker)
        expect(page).to have_no_content(offer1.unit_price_supplier)
      end
    end

    # TEST as a logged supplier
    # TEST when an offer owned by this supplier is asked for showing
    # TEST then the unit price supplier is presented
    # TEST then the unit price broker is not presented
    describe "as a logged supplier asking for an offer that he owns" do
      before :each do
        offer1.supplier = supplier1
        offer1.save
        sign_in(supplier1)
        visit supplier_offer_url(id: offer1.id, supplier_id: supplier1)
      end

      it "presents the supplier unit price" do
        expect(page).to have_content(offer1.unit_price_supplier)
        expect(page).to have_no_content(offer1.unit_price_broker)
      end
    end

    # TEST as a logged broker
    # TEST when a offer is asked for showing
    # TEST then the offer is assigned
    # TEST then the offer's show page is rendered
    describe "as a logged broker asking for a offer's page" do
      before :each do
        sign_in(broker1)
        visit offer_url(id: offer1.id)
      end

      it "presents the supplier and the broker unit price" do
        expect(page).to have_content(offer1.unit_price_supplier)
        expect(page).to have_content(offer1.unit_price_broker)
      end
    end
  end
end
