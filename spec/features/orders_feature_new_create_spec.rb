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

  describe "GET #new POST #create" do
    # TEST as a logged broker
    # TEST when an offer is display
    # TEST then i can place an order on it
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit offer_path(offer1)
      end

      it "can create an order from an offer" do
        click_link(I18n.t("orders.new"))
        expect(page).to have_xpath("//form[@action='/orders'
                                   and @method='post']")
        select_customer = find('select[name="order[customer_id]"]')
        expect(select_customer.find("option[value='" + customer1.id.to_s + "']").
          text).to eq(customer1.identifier)
        select(customer2.identifier, :from => 'order[customer_id]')
        check('order[approved]')
        fill_in('order_quantity', with: '5')
        fill_in('order[customer_observation]', :with => "a customer's observation")
        # save_and_open_page('./test.html')
        find('[name=commit]').click
        expect(page).to have_content(
          I18n.t('controllers.orders.successfully_created'))
        expect(page.current_url).to eq(
          'http://www.example.com/orders/' + Order.last.id.to_s)
        expect(page).to have_content(customer2.identifier)
        expect(page).to have_content(
          '5 ' + I18n.t('unit_types.' + supplier1.unit_type + '.symbol'))
        expect(page).to have_content(
          "a customer's observation")
        expect(page.find('input[name="approved"]').checked?).to be(true)
      end
    end
  end
end
