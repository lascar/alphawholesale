require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}
  let!(:order2) {create(:order, customer: customer2, offer: offer1)}

  describe "GET #new" do
    # TEST as a guest user
    # TEST when order is asked for new
    # TEST then it is routed to routing error
    it "does not routes /orders/new to orders#new" do
      expect(:get => "/orders/new").to route_to(controller: 'welcome',
                                                 action: 'routing_error',
                                                   url: 'orders/new')
    end

    # TEST as a logged supplier
    # TEST when order is asked for new
    # TEST then it is routed to routing error
    xit "does not routes get /suppliers/1/orders/new to orders#new" do
      # failed undefined method `authenticate?' for nil:NilClass
      sign_in(supplier1)
      expect(:get => "/suppliers/#{supplier1.id.to_s}/orders/new").to route_to(
        controller: 'welcome', action: 'routing_error',
        url: "suppliers/#{supplier1.id.to_s}/orders/1")
    end


    # TEST as a logged customer
    # TEST when order is asked for new
    # TEST then a new order is assigned
    # TEST and the new order's customer is the customer
    # TEST and the order's new page is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new, params: {customer_id: customer1.id, offer_id: offer1.id}
      end

      it "assigns a order new and puts the customer as the new order's customer and
          does not assign customers and render the new template" do
        expect(assigns(:order).persisted?).to be(false)
        expect(assigns(:order).customer_id).to be(customer1.id)
        expect(assigns(:customers)).to be(nil)
        expect(response).to render_template(:new)
      end
    end

  end
end
