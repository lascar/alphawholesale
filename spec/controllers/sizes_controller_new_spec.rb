  require 'rails_helper'

RSpec.describe SizesController, type: :controller do
  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:size1) {create(:size, product_id: product1.id)}
  let!(:size2) {create(:size, product_id: product2.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when size is asked for new
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :new
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.size.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when size is asked for new
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :new
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

    # TEST as a logged supplier
    # TEST when size is asked for new
    # TEST then a new size is assigned
    # TEST then the size's new page is rendered
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :new
      end

      it "assigns the size" do
        expect(assigns(:size).persisted?).to be(false)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end

    # TEST as a logged broker
    # TEST when size is asked for new
    # TEST then a new size is assigned
    # TEST and the list of suppliers is assigned
    # TEST and the size's new page is rendered
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :new
      end

      it "assigns the size" do
        expect(assigns(:size).persisted?).to be(false)
      end

      it "assigns the list of suppliers" do
        expect(assigns(:suppliers).sort).to eq(
         Supplier.all.pluck(:identifier, :id).sort)
      end

      it "render the new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end
