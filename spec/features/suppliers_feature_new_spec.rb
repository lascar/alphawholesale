require 'rails_helper'

RSpec.describe "Suppliers Feature", type: :feature do
  let!(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

  describe "GET #new" do

    # TEST as a logged broker
    # TEST when supplier is asked for new
    # TEST then a new supplier is assigned
    describe "as a logged broker" do
      before :each do
        sign_in(broker1)
        visit new_supplier_url
      end

      it "assigns a new supplier" do
        expect(page).to have_field({name: "supplier[identifier]"})
      end
    end
  end
end
