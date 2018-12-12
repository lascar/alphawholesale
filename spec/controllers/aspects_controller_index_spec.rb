require 'rails_helper'

RSpec.describe AspectsController, type: :controller do

  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:aspect1) {create(:aspect, product_id: product1.id)}
  let!(:aspect2) {create(:aspect, product_id: product2.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of aspects is asked for
    # TEST then the 'welcome' page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :index
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(I18n.t(
         'devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when the list of aspects is asked for
    # TEST then all the aspects are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index
      end

      it "assigns all aspects" do
        expect(assigns(:aspects).sort).to eq(Aspect.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of aspects is asked for
    # TEST then all the aspects are assigned
    # TEST and it renders the index
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :index
      end

      it "assigns all aspects" do
        expect(assigns(:aspects).sort).to eq(Aspect.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged broker
    # TEST when the list of aspects is asked for
    # TEST then all the aspects are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :index
      end

      it "assigns all aspects" do
        expect(assigns(:aspects).sort).to eq(Aspect.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end
  end
end
