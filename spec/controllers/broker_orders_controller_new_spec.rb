require 'rails_helper'

RSpec.describe BrokerOrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}

  describe "GET #new" do

    # TEST as a logged broker
    # TEST when order is asked for new
    # TEST then a new order is assigned
    # TEST and the new order's customer is the customer
    # TEST and the order's new page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new, params: {broker_id: broker1.id, offer_id: offer1, customer_id: customer1.id}
      end

      it "assigns a order new and puts the broker as the new order's broker and
          does not assign brokers and render the new template" do
        expect(assigns(:order).persisted?).to be(false)
        expect(assigns(:order).customer_id).to be(customer1.id)
        expect(assigns(:customers)).to eq([[customer1.identifier, customer1.id]])
        expect(response).to render_template(:new)
      end
    end

  end
end
