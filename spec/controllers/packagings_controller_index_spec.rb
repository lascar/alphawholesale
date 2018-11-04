require 'rails_helper'

RSpec.describe PackagingsController, type: :controller do

  let!(:product1) {create(:product)}
  let!(:product2) {create(:product)}
  let!(:packaging1) {create(:packaging, product_id: product1.id)}
  let!(:packaging2) {create(:packaging, product_id: product2.id)}
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of packagings is asked for
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
         'devise.failure.offer.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when the list of packagings is asked for
    # TEST then all the packagings are assigned
    # TEST and it renders the index
    describe "as a logged customer" do
      before :each do
        sign_in(customer1)
        get :index
      end

      it "assigns all packagings" do
        expect(assigns(:packagings).sort).to eq(Packaging.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged supplier
    # TEST when the list of packagings is asked for
    # TEST then all the packagings are assigned
    # TEST and it renders the index
    describe "as a logged supplier" do
      before :each do
        sign_in(supplier1)
        get :index
      end

      it "assigns all packagings" do
        expect(assigns(:packagings).sort).to eq(Packaging.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end

    # TEST as a logged broker
    # TEST when the list of packagings is asked for
    # TEST then all the packagings are assigned
    # TEST and it renders the index
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        get :index
      end

      it "assigns all packagings" do
        expect(assigns(:packagings).sort).to eq(Packaging.with_approved(true).sort)
      end

      it "renders the index" do
        expect(response).to render_template(:index)
      end
    end
  end
end
