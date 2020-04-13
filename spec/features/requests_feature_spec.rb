require 'rails_helper'

RSpec.describe "Requests Feature", type: :feature do

  let!(:product1) {create(:product)}
  let(:variety1) {product1.assortments["varieties"].first}
  let(:aspect1) {product1.assortments["aspects"].last}
  let(:packaging1) {product1.assortments["packagings"].last}
  let(:size1) {product1.assortments["sizes"].last}
  let(:caliber1) {product1.assortments["calibers"].last}
  let!(:concrete_product1) {create(:concrete_product, product: product1.name,
    variety: variety1, aspect: aspect1, packaging: packaging1, size: size1,
                                  caliber: caliber1)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let!(:broker1) {create(:broker)}

  describe "request use case" do
    # TEST as a logged supplier I can create a new non approved request
    # TEST as a logged broker I can appoved the newly created request
    # TEST then a interested supplier receives an email upon this request
    # TEST as a logged supplier I can order on this request
    describe "as a logged customer" do

      it "goes through to the process request/order" do
        supplier1.products = [product1]
        supplier1.concrete_products << concrete_product1
        supplier1.save
        customer1.products = [product1]
        customer1.concrete_products << concrete_product1
        customer1.save
        sign_in(customer1)
        visit customer_url(customer1)
        find("a[href='/customers/#{customer1.id.to_s}/requests/']").click
        within('#form_new_request') do
          select(product1.name, :from => 'new_request[product]')
          find('[name=commit]').click
        end
        within('#form_create_request') do
          within('#radios_varieties') do
            choose 'request_concrete_product_variety_' + variety1
          end
        end
        fill_in 'request_quantity', :with => 2
        fill_in 'request_date_start', with: Time.now
        fill_in 'request_date_end', with: Time.now + 5.days
        find('[name=commit]').click
        find("a[href='/customers/sign_out']").click
        request1 = Request.last
        sign_in(broker1)
        visit broker_url(broker1)
        find("a[href='/brokers/#{broker1.id.to_s}/requests/#{request1.id.to_s}/edit']").click
        check('request_approved')
        find('[name=commit]').click
        find("a[href='/brokers/sign_out']").click
        # sign_in(supplier1)
        # visit supplier_requests_url(supplier1)
        # find("a[href='/suppliers/#{supplier1.id.to_s}/requests/#{request1.id.to_s}']").click
        # find("a[href='/suppliers/#{supplier1.id.to_s}/orders/new?request_id=#{request1.id.to_s}']").click
        # fill_in 'order_quantity', :with => 1
        # find('[name=commit]').click
        # order1 = Order.last
        # expect(page).to have_no_content(order1.unit_price_supplier.to_s + ' ' +
        #                              I18n.t("currencies." +
        #                                     request1.supplier.currency + ".symbol"))
        # expect(page).to have_content(Order.last.unit_price_broker.to_s + ' ' +
        #                              I18n.t("currencies." +
        #                                     request1.supplier.currency + ".symbol"))
        # expect(page).to have_content(I18n.t('controllers.orders.successfully_created'))
      end
    end
  end
end
