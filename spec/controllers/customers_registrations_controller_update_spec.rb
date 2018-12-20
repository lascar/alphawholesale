require 'rails_helper'
# ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER
#
# `rails-controller-testing` gem.

RSpec.describe Customers::RegistrationsController, type: :controller do
  let(:customer1) {create(:customer)}
  let!(:customer2) {create(:customer, identifier: 'customer2',
                                      email: 'customer2@test.com')}
  let(:customer_hash) {{identifier: 'customer3', email: 'customer3@test.com',
                       tin: 'en', country: 'spain', entreprise_name: 'star treck',
                       password: 'password', password_confirmation: 'password',
                       approved: true}}
  let!(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe 'PUT #update' do

    # TEST as a guest user
    # TEST when a customer is asked for updating
    # TEST then the customer sign_in page is returned
    # TEST and a message of not signed is sent
    describe 'as a guest user asking for creating a customer' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:customer]
        put :update, params: {id: customer2.id, customer: customer_hash}
      end

      it 'returns the root page and returns a not signed message' do
        expect(response.redirect_url).to eq(
         'http://test.host/customers/sign_in')
        expect(flash.alert).to match(
                I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged supplier
    # TEST when a customer is asked for updating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe 'as a logged supplier asking for creating a customer' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(supplier1)
        put :update, params: {id: customer2.id, customer: customer_hash}
      end

      it "returns the supplier's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         'http://test.host/suppliers/' + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged customer
    # TEST when the customer is asked for updating other customer's registration
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for
     updating an other customer's registration" do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:customer]
        sign_in(customer1)
        put :update, params: {id: customer2.id, customer: customer_hash}
      end

      it "returns the customer's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          'http://test.host/customers/' + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end
  end
end
