require 'rails_helper'

# A new supplier can be registred by guest user (but not approved)
# A supplier can modify his own registration (but not approval or identity) if
# he provides his current password
RSpec.describe 'Suppliers Feature', type: :feature do
  let(:broker1) {create(:broker)}
  let(:supplier1) {create(:supplier, password: 'password1')}
  let(:supplier_hash) {{identifier: 'identifier', email: 'supplier2@test.com',
                       tin: 'en', entreprise_name: 'star treck',
                       street_and_number: 'street_and_number', city: 'city',
                       code_postal: 'code_postal', country: 'spain', state: 'state',
                       telephone_number1: 'telephone_number1',
                       password: 'password2', password_confirmation: 'password2',
                       current_password: 'password1'}}

  describe 'GET #new' do

    # TEST as a guest user
    # TEST when a new supplier is submited
    # TEST then a message of signed but not approved is sent
    describe 'as a guest user' do

      it 'assigns a new supplier' do
        visit new_supplier_registration_url
        expect(page).to have_xpath("//form[@action='/suppliers' and @method='post']")
        expect(page).not_to have_field({name: 'supplier[approved]'})
        fill_in('supplier[identifier]', :with => supplier_hash[:identifier])
        fill_in('supplier[email]', :with => supplier_hash[:email])
        fill_in('supplier[entreprise_name]', :with => supplier_hash[:entreprise_name])
        fill_in('supplier[tin]', :with => supplier_hash[:tin])
        fill_in('supplier[street_and_number]', :with => supplier_hash[:street_and_number])
        fill_in('supplier[city]', :with => supplier_hash[:city])
        fill_in('supplier[postal_code]', :with => supplier_hash[:postal_code])
        fill_in('supplier[state]', :with => supplier_hash[:state])
        fill_in('supplier[country]', :with => supplier_hash[:country])
        fill_in('supplier[telephone_number1]', :with => supplier_hash[:telephone_number1])
        fill_in('supplier[telephone_number2]', :with => supplier_hash[:telephone_number2])
        fill_in('supplier[password]', :with => supplier_hash[:password])
        fill_in('supplier[password_confirmation]', :with => supplier_hash[:password])
        find('[name=commit]').click
        expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_not_approved'))
      end
    end

    # TEST as a logged supplier
    # TEST when registration edit is asked
    # TEST then a message of success is sent
    describe 'as a logged broker' do
      before :each do
        sign_in(supplier1)
      end

      it 'assigns a new supplier' do
        visit edit_supplier_registration_url
        expect(page).to have_xpath(
         "//form[@action='/suppliers' and @method='post']")
        expect(page).not_to have_field({name: 'supplier[identifier]'})
        expect(page).not_to have_field({name: 'supplier[approved]'})
        expect(page.find_field('supplier[email]').value).to eq(supplier1.email)
        expect(page.find_field('supplier[country]').value).
          to eq(supplier1.country)
        fill_in('supplier[password]', :with => supplier_hash[:password])
        fill_in('supplier[password_confirmation]', :with => supplier_hash[:password])
        fill_in('supplier[current_password]', :with => 'password1')
        find('[name=commit]').click
        expect(page).to have_content(I18n.t('devise.registrations.updated'))
        supplier = Supplier.find_by_identifier(supplier1.identifier)
        expect(supplier.valid_password?(supplier_hash[:password])).to be(true)
      end
    end

  end
end
