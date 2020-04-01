require 'rails_helper'

RSpec.describe "Offers Feature", type: :feature do

  let!(:product1) {create(:product)}
  let(:variety1) {product1.assortments["varieties"].first}
  let(:aspect1) {product1.assortments["aspects"].last}
  let(:packaging1) {product1.assortments["packagings"].last}
  let(:size1) {product1.assortments["sizes"].last}
  let(:caliber1) {product1.assortments["calibers"].last}
  let!(:attached_product1) {create(:attached_product, product: product1.name,
    variety: variety1, aspect: aspect1, packaging: packaging1, size: size1,
                                  caliber: caliber1)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let!(:broker1) {create(:broker)}

  describe "offer use case" do
    # TEST as a logged supplier I can create a new non approved offer
    # TEST as a logged broker I can appoved the newly created offer
    # TEST then a interested supplier receives an email upon this offer
    # TEST as a logged customer I can order on this offer
    describe "as a logged customer" do

      it "goes through to the process offer/order" do
        supplier1.products = [product1.name]
        supplier1.attached_products << attached_product1
        supplier1.save
        customer1.products = [product1.name]
        customer1.attached_products << attached_product1
        customer1.save
        sign_in(supplier1)
        visit supplier_url(supplier1)
        find("a[href='/suppliers/#{supplier1.id.to_s}/offers/']").click
        within('#form_new_offer') do
          select(product1.name, :from => 'new_offer[product]')
          find('[name=commit]').click
        end
        within('#form_create_offer') do
          within('#radios_varieties') do
            choose 'offer_attached_product_variety_' + variety1
          end
        end
        fill_in 'offer_quantity', :with => 2
        fill_in 'offer_unit_price_supplier', :with => 4
        select(INCOTERMS.last, :from => 'offer_incoterm')
        fill_in 'offer_localisation_supplier', :with => 'salobreña'
        fill_in 'offer_date_start', with: Time.now
        fill_in 'offer_date_end', with: Time.now + 5.days
        find('[name=commit]').click
        find("a[href='/suppliers/sign_out']").click
        offer1 = Offer.last
        sign_in(broker1)
        visit broker_url(broker1)
        find("a[href='/brokers/#{broker1.id.to_s}/offers/#{offer1.id.to_s}/edit']").click
        fill_in 'offer_unit_price_broker', :with => 5
        fill_in 'offer_localisation_broker', :with => 'Granada'
        check('offer_approved')
        find('[name=commit]').click
        find("a[href='/brokers/sign_out']").click
        sign_in(customer1)
        visit customer_offers_url(customer1)
        find("a[href='/customers/#{customer1.id.to_s}/offers/#{offer1.id.to_s}']").click
        find("a[href='/customers/#{customer1.id.to_s}/orders/new?offer_id=#{offer1.id.to_s}']").click
        fill_in 'order_quantity', :with => 1
        find('[name=commit]').click
        order1 = Order.last
        expect(page).to have_no_content(order1.unit_price_supplier.to_s + ' ' +
                                     I18n.t("currencies." +
                                            offer1.supplier.currency + ".symbol"))
        expect(page).to have_content(Order.last.unit_price_broker.to_s + ' ' +
                                     I18n.t("currencies." +
                                            offer1.supplier.currency + ".symbol"))
        expect(page).to have_content(I18n.t('controllers.orders.successfully_created'))
      end
    end
  end
end
