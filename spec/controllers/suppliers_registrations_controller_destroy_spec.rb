require 'rails_helper'
# ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER
#
# `rails-controller-testing` gem.

RSpec.describe Suppliers::RegistrationsController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier)}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe 'DELETE #destroy' do

    # TEST as a guest user
    # TEST when a supplier is asked for destroying his registration
    # TEST then the supplier sign_in page is returned
    # TEST and a message of not signed is sent
    describe "as a guest user asking for destroying a supplier's registration" do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        delete :destroy, params: {id: supplier1.id}
      end

      it 'returns the root page and returns a not signed message' do
        expect(response.redirect_url).to eq(
         'http://test.host/suppliers/sign_in')
        expect(flash.alert).to match(
                I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for destroying his registration
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for destroying
    a supplier's registration" do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(customer1)
        delete :destroy, params: {id: supplier1.id}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         'http://test.host/customers/' + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for destroying his registration
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe 'as a logged supplier asking for destroying his registration' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(supplier1)
        delete :destroy, params: {id: supplier1.id}
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          'http://test.host/suppliers/' + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for destroying other supplier's registration
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for destroying
    other supplier's registration" do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(supplier1)
        delete :destroy, params: {id: supplier2.id}
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          'http://test.host/suppliers/' + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged broker
    # TEST when the supplier is asked for destroying his registration
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for destroying
    other supplier's registration" do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(broker1)
        delete :destroy, params: {id: supplier1.id}
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          'http://test.host/suppliers/')
        expect(flash.alert).to match(
        I18n.t('controllers.suppliers_registrations.action_not_allowed_from_here'))
      end
    end
  end
end
