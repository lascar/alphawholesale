require 'rails_helper'

RSpec.describe 'Suppliers feature index', type: :feature do
  let(:broker1) {create(:broker)}
  let!(:supplier1) {create(:supplier, approved: true)}
  let!(:supplier2) {create(:supplier, approved: false)}

  # TEST as a logged broker
  # TEST when the list of suppliers is asked for
  # TEST then the list of suppliers is returned
  describe "as a logged broker" do
    before :each do
      sign_in(broker1)
      visit '/suppliers'
    end

    it "returns the list of suppliers approved" do
      expect(page).to have_content supplier1.identifier
    end

    it "does not return the not approved suppliers" do
      expect(page).to have_no_content supplier2.identifier
    end
  end
end

