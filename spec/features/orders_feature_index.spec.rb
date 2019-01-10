require 'rails_helper'

RSpec.describe "Orders Feature", type: :feature do

  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:supplier1) {create(:supplier, unit_type: "kilogram")}
  let(:supplier2) {create(:supplier, unit_type: "pound")}
  let(:broker1) {create(:broker)}
  let(:offer1) {create(:offer, approved: true, quantity: 10,
                                unit_price_supplier: 0.1, unit_price_broker: 0.2,
                                supplier_id: supplier1.id)}
  let(:offer2) {create(:offer, approved: true, quantity: 20,
                                unit_price_supplier: 0.3, unit_price_broker: 0.4,
                                supplier_id: supplier2.id)}
  let(:offer3) {create(:offer, approved: true,quantity: 30,
                                unit_price_supplier: 0.5, unit_price_broker: 0.6,
                                supplier_id: supplier1.id)}
  let!(:order1) {create(:order, approved: true, quantity: 5, offer_id: offer1.id,
                                customer_id: customer1.id)}
  let!(:order2) {create(:order, approved: true, quantity: 15, offer_id: offer2.id,
                                customer_id: customer2.id)}
  let!(:order3) {create(:order, approved: false, quantity: 25, offer_id: offer3.id,
                                customer_id: customer1.id)}

  describe "GET #index" do
    # TEST as a logged customer 
    # TEST when the list of orders is asked for
    # TEST then all the customer's orders are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        visit customer_orders_url(customer1)
      end

      it "presentes only approved orders" do
        expect(page).to have_content(order1.quantity.to_s + " " +
         I18n.t("unit_types." + order1.offer.supplier.unit_type + ".symbol"))
        expect(page).to have_content(order3.quantity.to_s + " " +
         I18n.t("unit_types." + order3.offer.supplier.unit_type + ".symbol"))
          expect(page).to have_no_content(order2.quantity.to_s + " " +
         I18n.t("unit_types." + order2.offer.supplier.unit_type + ".symbol"))
      end
    end

    # TEST as a logged supplier 
    # TEST when the list of orders is asked for
    # TEST then all the orders approved that are from an this supplier's offer
    # TEST are listed
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        visit supplier_orders_url(supplier1)
      end

      it "presentes only approved orders" do
        expect(page).to have_content(order1.quantity.to_s + " " +
         I18n.t("unit_types." + order1.offer.supplier.unit_type + ".symbol"))
        expect(page).to have_no_content(order2.quantity.to_s + " " +
         I18n.t("unit_types." + order2.offer.supplier.unit_type + ".symbol"))
          expect(page).to have_no_content(order3.quantity.to_s + " " +
         I18n.t("unit_types." + order3.offer.supplier.unit_type + ".symbol"))
      end
    end

    # TEST as a logged broker
    # TEST when the list of orders is asked for
    # TEST then all the orders are listed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit orders_url
      end

      it "presentes only approved orders" do
        expect(page).to have_content(order1.quantity.to_s + " " +
         I18n.t("unit_types." + order1.offer.supplier.unit_type + ".symbol"))
        expect(page).to have_content(order2.quantity.to_s + " " +
         I18n.t("unit_types." + order2.offer.supplier.unit_type + ".symbol"))
          expect(page).to have_no_content(order3.quantity.to_s + " " +
         I18n.t("unit_types." + order3.offer.supplier.unit_type + ".symbol"))
      end
    end
  end
end
