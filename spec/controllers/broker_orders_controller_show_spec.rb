require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:offer1) {create(:offer, supplier: supplier1)}
  let!(:order1) {create(:order, customer: customer1, offer: offer1)}
  let!(:order2) {create(:order, customer: customer2)}

  describe "GET #show" do

    # TEST as a logged broker
    # TEST when a order is asked for showing
    # TEST then the order is assigned
    # TEST then the order's show page is rendered
    describe "as a logged broker asking for a order's page" do
      before :each do
        @controller = BrokerOrdersController.new
        sign_in(broker1)
        get :show, params: {broker_id: broker1.id, id: order1.to_param}
      end

      it "assigns the order" do
        expect(assigns(:order)).to eq(order1)
      end

      it "render the show template" do
        expect(response).to render_template(:show)
      end
    end
  end
end
