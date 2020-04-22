require 'rails_helper'

RSpec.describe BrokerOrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:order1) {create(:order, customer_id: customer1.id)}
  let!(:order2) {create(:order, customer_id: customer2.id)}

  describe "DELETE #destroy" do
    # TEST as a logged broker
    # TEST when a order  is asked for destroying
    # TEST then the list of orders is returned
    # TEST and a message of success in destroying is send
    # TEST and the order is destroyed
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        delete :destroy, params: {broker_id: broker1.id, id: order1.to_param}
      end

      it "returns the list of orders" do
        expect(response.redirect_url).to eq("http://test.host/brokers/#{broker1.id.to_s}/orders/")
      end

      it "returns a success message" do
        expect(flash.notice).to match(
         I18n.t('controllers.orders.successfully_destroyed'))
      end

      it "destroys the order" do
        expect(Order.find_by_id(order1.id)).to be(nil)
      end
    end
  end
end
