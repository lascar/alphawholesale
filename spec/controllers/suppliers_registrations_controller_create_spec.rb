require 'rails_helper'
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

  describe 'POST #create' do

    # TEST as a guest user
    # TEST when a supplier is asked for creating with approved to true
    # TEST then the root page is returned
    # TEST and a message of signed_up_but_not_approved is sent
    # TEST and the newly created supplier is not approved
    describe 'as a guest user asking for creating a supplier' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        post :create, params: {supplier: supplier_hash}
      end

      it 'returns the root page and returns a signed_up_but_not_approved message' do
        expect(response.redirect_url).to eq(
         'http://test.host/')
        expect(flash.notice).to match(
         I18n.t('devise.registrations.signed_up_but_not_approved'))
        expect(Supplier.last.approved).to be(false)
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for creating
    # TEST then the customer's page is returned
    # TEST and a message of unauthorized is send
    describe 'as a logged customer asking for creating a supplier' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(customer1)
        post :create, params: {supplier: supplier_hash}
      end

      it "returns the customer's page and returns a non authorized message" do
        expect(response.redirect_url).to eq(
         'http://test.host/customers/' + customer1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for creating
    # TEST then the supplier's page is returned
    # TEST and a message of unauthorized is send
    describe 'as a logged supplier asking for creating his identifier and email' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:supplier]
        sign_in(supplier1)
        post :create, params: {supplier: supplier_hash}
      end

      it "returns the supplier's page and
          returns a already authenticated message" do
        expect(response.redirect_url).to eq(
          'http://test.host/suppliers/' + supplier1.id.to_s)
        expect(flash.alert).to match(
         I18n.t('devise.failure.already_authenticated'))
      end
    end
  end
end
