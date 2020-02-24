require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:customer2) {create(:customer)}
  let(:broker1) {create(:broker)}
  let(:product1) {create(:product)}
  let!(:order1) {create(:order, customer: customer1)}
  let!(:order2) {create(:order, customer: customer2)}

  describe "GET #edit" do

    # TEST as a logged customer
    # TEST when order owned by other customer is asked for editing
    # TEST then the customer's page is returned
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {customer_id: customer1.id, id: order2.to_param}
      end

      it "returns the customer's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/customers/" + customer1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end

    end

    # TEST as a logged customer
    # TEST when order owned by the customer is asked for editing
    # TEST then the edited order is assigned
    # TEST and customers is not assigned
    # TEST and the customer is the customer's order
    # TEST and the new template is rendered
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :edit, params: {customer_id: customer1.id, id: order1.to_param}
      end

      it "assigns a new order" do
        expect(assigns(:order).persisted?).to be(true)
      end

      it "does not assign customers" do
        expect(assigns(:customers)).to be(nil)
      end

      it "assigns the customer to the new order" do
        expect(assigns(:order).customer).to eq(customer1)
      end

      it "redirect to the newly created order" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
