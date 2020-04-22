require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  let(:customer1) {create(:customer)}
  let(:supplier1) {create(:supplier)}
  let(:supplier2) {create(:supplier)}
  let(:broker1) {create(:broker)}
  let!(:offer1) {create(:offer, supplier: supplier1)}
  let!(:offer2) {create(:offer, supplier: supplier2)}

  describe "GET #new" do
    # TEST as a guest user
    # TEST when offer is asked for new
    # TEST then 404 is returned
    describe "as guest user" do
			it "does not routes get /offers/new to offers#new" do
				expect{ get :new  }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end

    # TEST as a logged customer
    # TEST when offer is asked for creating
    # TEST then 404 is returned
    describe "as a customer" do
			it "does not routes post /customers/1/offers to offers#create" do
        sign_in(customer1)
				expect{ get :new, params: {customer_id: customer1.id} }.
         to raise_error(ActionController::UrlGenerationError)
			end
    end
  end
end
