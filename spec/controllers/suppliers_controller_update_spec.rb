require 'rails_helper'
# `rails-controller-testing` gem.

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier1) {create(:supplier)}
  let!(:supplier2) {create(:supplier, identifier: "supplier2",
                                      email: "supplier2@test.com")}
  let(:customer1) {create(:customer)}
  let(:broker1) {create(:broker)}

  describe "PUT #update" do

    # TEST as a guest user
    # TEST when a supplier is asked for updating
    # TEST then the root page is return
    # TEST and a message of unauthenticated is send
    describe "as guest user send for updating a supplier" do
      before :each do
        put :update,
         params: {id: supplier1.to_param,
                  supplier: (attributes_for(:supplier,
                                            identifier: "supplier3",
                                            email: "supplier3@test.com"))}
      end

      it "returns the root page" do
        expect(response.redirect_url).to eq("http://test.host/")
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end

    # TEST as a logged customer
    # TEST when a supplier is asked for updating
    # TEST then the customer's page is return
    # TEST and a message of unauthorized is send
    describe "as a logged customer asking for updating a supplier" do
      before :each do
        sign_in(customer1)
        put :update,
         params: {id: supplier1.to_param,
                  supplier: (attributes_for(:supplier,
                                            identifier: "supplier3",
                                            email: "supplier3@test.com"))}
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
    # TEST when an other supplier is asked for updating
    # TEST then the supplier's page is return
    # TEST and a message of unauthorized is send
    describe "as a logged supplier asking for updating an other supplier" do
      before :each do
        sign_in(supplier1)
        put :update,
         params: {id: supplier2.to_param,
                  supplier: (attributes_for(:supplier,
                                            identifier: "supplier3",
                                            email: "supplier3@test.com"))}
      end

      it "returns the supplier's page" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end

      it "returns a non authorized message" do
        expect(flash.alert).to match(
         I18n.t('devise.errors.messages.not_authorized'))
      end
    end

    # TEST as a logged supplier
    # TEST when the supplier is asked for updating his identifier and email
    # TEST then the identifier remains unchanged but the email does
    # TEST and a message ok for change is send
    # TEST and the request is redirect at the show page
    describe "as a logged supplier asking for updating
     his identifier and email" do
      before :each do
        sign_in(supplier1)
        put :update,
         params: {id: supplier1.to_param,
                  supplier: (attributes_for(:supplier,
                                            identifier: "supplier3",
                                            email: "supplier3@test.com"))}
      end

      it "the identifier remains unchanged" do
        expect(Supplier.find(supplier1.id).identifier).to eq(supplier1.identifier)
      end

      it "the email has changed" do
        expect(Supplier.find(supplier1.id).email).to eq("supplier3@test.com")
      end

      it "the supplier's page is retured" do
        expect(response.redirect_url).to eq(
         "http://test.host/suppliers/" + supplier1.id.to_s)
      end
    end

    # TEST as a logged broker
    # TEST when a supplier is asked for updating his identifier and email
    # TEST then the identifier and the email are changed
    describe "as a logged broker asking for updating
     a supplier's identifier and email" do
      before :each do
        sign_in(broker1)
        put :update,
         params: {id: supplier1.to_param,
                  supplier: (attributes_for(:supplier,
                                            identifier: "supplier3",
                                            email: "supplier3@test.com"))}
      end

      it "changes the supplier's identifier" do
        expect(Supplier.find(supplier1.id).identifier).to eq("supplier3")
      end

      it "changes the supplier's email" do
        expect(Supplier.find(supplier1.id).email).to eq("supplier3@test.com")
      end
    end
  end
end
