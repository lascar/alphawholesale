require 'rails_helper'

RSpec.describe "Suppliers Feature", type: :feature do
  let(:broker1) {create(:broker)}
  let(:supplier_hash) {{identifier: "supplier2", email: "supplier2@test.com",
                       tin: "en", country: "spain", entreprise_name: "star treck",
                       password: "password", password_confirmation: "password",
                       approved: true}}

  describe "GET #new" do

    # TEST as a guest user
    # TEST when a new supplier is submited
    # TEST then a message of signed but not approved is sent
    describe "as a guest user" do

      it "assigns a new supplier" do
        visit new_supplier_registration_url
        expect(page).to have_xpath("//form[@action='/suppliers'
                                   and @method='post']")
        expect(page).not_to have_field({name: "supplier[approved]"})
        fill_in('supplier[identifier]', :with => 'identifier')
        fill_in('supplier[email]', :with => 'email@example.com')
        fill_in('supplier[entreprise_name]', :with => 'entreprise')
        fill_in('supplier[tin]', :with => 'tin')
        fill_in('supplier[street_and_number]', :with => 'street_and_number')
        fill_in('supplier[city]', :with => 'city')
        fill_in('supplier[postal_code]', :with => 'postal_code')
        fill_in('supplier[state]', :with => 'state')
        fill_in('supplier[country]', :with => 'country')
        fill_in('supplier[telephone_number1]', :with => '111')
        fill_in('supplier[telephone_number2]', :with => '222')
        fill_in('supplier[password]', :with => 'password')
        fill_in('supplier[password_confirmation]', :with => 'password')
        find('[name=commit]').click
        expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_not_approved'))
      end
    end

    # TEST as a logged broker
    # TEST when a new supplier is submited
    # TEST then a message of success is sent
    describe "as a logged broker" do

      it "assigns a new supplier" do
        sign_in(broker1)
        visit new_supplier_registration_url
        expect(page).to have_xpath("//form[@action='/suppliers'
                                   and @method='post']")
        expect(page).to have_field({name: "supplier[approved]"})
        check({name: "supplier[approved]"})
        fill_in('supplier[identifier]', :with => 'identifier')
        fill_in('supplier[email]', :with => 'email@example.com')
        fill_in('supplier[entreprise_name]', :with => 'entreprise')
        fill_in('supplier[tin]', :with => 'tin')
        fill_in('supplier[street_and_number]', :with => 'street_and_number')
        fill_in('supplier[city]', :with => 'city')
        fill_in('supplier[postal_code]', :with => 'postal_code')
        fill_in('supplier[state]', :with => 'state')
        fill_in('supplier[country]', :with => 'country')
        fill_in('supplier[telephone_number1]', :with => '111')
        fill_in('supplier[telephone_number2]', :with => '222')
        fill_in('supplier[password]', :with => 'password')
        fill_in('supplier[password_confirmation]', :with => 'password')
        find('[name=commit]').click
        expect(page).to have_content(I18n.t('controllers.suppliers.successfully_created'))
        expect(Supplier.last.approved).to be(true)
      end
    end
  end
end
