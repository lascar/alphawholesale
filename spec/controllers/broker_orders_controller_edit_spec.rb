require 'rails_helper'

RSpec.describe BrokerOrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:order1) {create(:order, customer: customer1)}
  let!(:order2) {create(:order, customer: customer2)}

  # TEST as a logged broker
  # TEST when a order is asked for edit
  # TEST then the asked order is assigned
  # TEST and customers is assigned
  # TEST then the order's edit page is rendered
  describe "as a logged broker" do
    before :each do
      sign_in(broker1)
      get :edit, params: {broker_id: broker1.id, id: order1.to_param}
    end

    it "assigns the order" do
      expect(assigns(:order)).to eq(order1)
    end

    it "assigns customers" do
      expect(assigns(:customers).sort).to eq(
       Customer.all.pluck(:identifier, :id).sort)
    end

    it "render the edit template" do
      expect(response).to render_template(:edit)
    end
  end
end
