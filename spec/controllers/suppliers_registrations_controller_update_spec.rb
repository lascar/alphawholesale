require 'rails_helper'
# ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER
#
# `rails-controller-testing` gem.

RSpec.describe Suppliers::RegistrationsController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier, identifier: 'supplier2',
                                      email: 'supplier2@test.com')}
  let(:supplier_hash) {{identifier: 'supplier3', email: 'supplier3@test.com',
                       tin: 'en', country: 'spain', entreprise_name: 'star treck',
                       password: 'password', password_confirmation: 'password',
                       approved: true}}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe 'PUT #update' do

    # TEST as a guest user
    # TEST when a supplier is asked for updating
    # TEST then the supplier sign_in page is returned
    # TEST and a message of not signed is sent
    describe 'as a guest user asking for creating a supplier' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        put :update, params: {id: supplier2.id, supplier: supplier_hash}
      end

      it 'returns the root page and returns a not signed message' do
        expect(response.redirect_url).to eq(
         'http://test.host/suppliers/sign_in')
        expect(flash.alert).to match(
                I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for updating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe 'as a logged customer asking for creating a supplier' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(customer1)
        put :update, params: {id: supplier2.id, supplier: supplier_hash}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         'http://test.host/customers/' + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for updating other supplier's registration
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe 'as a logged supplier asking for creating his identifier and email' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(supplier1)
        put :update, params: {id: supplier2.id, supplier: supplier_hash}
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          'http://test.host/suppliers/' + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end
  end
end
