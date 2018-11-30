require 'rails_helper'

RSpec.describe "Customers Feature", type: :feature do
  let!(:customer1) {create(:customer, approved: true)}
  let!(:customer2) {create(:customer, approved: false)}
  let(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #index" do

    # TEST as a logged broker
    # TEST when the list of customers is asked for
    # TEST then the list of approved customers is returned
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit '/customers'
      end

      it "returns the list of customers approved" do
        expect(page).to have_content customer1.identifier
        expect(page).to have_no_content customer2.identifier
      end
    end
  end
end
