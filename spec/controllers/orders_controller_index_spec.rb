require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}

  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of orders is asked
    # TEST then it is routed to routing error
    it "does not routes /orders to orders#index" do
      expect(:get => "/orders").to route_to(controller: 'welcome',
                                              action: 'routing_error',
                                              url: 'orders')
    end
  end
end
