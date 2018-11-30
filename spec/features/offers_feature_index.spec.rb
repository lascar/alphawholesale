require 'rails_helper'

RSpec.describe "Offers Feature", type: :feature do

  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:product1) {create(:product)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, approved: true, currency: "euro",
                                unit_price_supplier: 0.1, unit_price_broker: 0.2)}
  let!(:offer2) {create(:offer, approved: true, currency: "euro",
                                unit_price_supplier: 0.3, unit_price_broker: 0.4)}
  let!(:offer3) {create(:offer, approved: false, currency: "euro",
                                unit_price_supplier: 0.5, unit_price_broker: 0.6)}

  describe "GET #index" do
    # TEST as a logged customer
    # TEST when the list of offers is asked for
    # TEST then all the approved offers that have product attached to the customer
    describe "as a logged customer" do
      before :each do
        offer1.product = product1
        offer1.save
        customer1.products = [product1]
        customer1.save
        sign_in(customer1)
        visit customer_offers_url(customer1)
      end

      it "presentes only approved offers that are product attached to the customer" do
        expect(page).to have_no_content("0.1")
        expect(page).to have_content("0.2")
        expect(page).to have_no_content("0.3")
        expect(page).to have_no_content("0.4")
        expect(page).to have_no_content("0.5")
        expect(page).to have_no_content("0.6")
      end
    end

    # TEST as a logged supplier
    # TEST when the list of offers is asked for
    # TEST then all the offers that belong to the supplier are presented
    describe "as a logged supplier" do
      before :each do
        offer1.supplier = supplier1
        offer1.save
        offer3.supplier = supplier1
        offer3.save
        sign_in(supplier1)
        visit supplier_offers_url(supplier1)
      end

      it "presentes only approved offers that are product attached to the supplier" do
        expect(page).to have_content("0.1")
        expect(page).to have_no_content("0.2")
        expect(page).to have_no_content("0.3")
        expect(page).to have_no_content("0.4")
        expect(page).to have_content("0.5")
        expect(page).to have_no_content("0.6")
      end
    end

    # TEST as a logged broker
    # TEST when the list of offers is asked for
    # TEST then all the offers are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit offers_url
      end

      it "presentes only approved offers" do
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