require 'rails_helper'

# A new supplier can be registred by guest user (but not approved)
# A supplier can modify his own registration (but not approval or identity) if
# he provides his current password
RSpec.describe 'Suppliers Feature new', type: :feature do
  let(:broker1) {create(:broker)}
  let(:supplier_hash) {{identifier: 'identifier', email: 'supplier2@test.com',
                       tin: 'en', entreprise_name: 'star treck',
                       street_and_number: 'street_and_number', city: 'city',
                       code_postal: 'code_postal', country: 'spain', state: 'state',
                       telephone_number1: 'telephone_number1',
                       telephone_number1: 'telephone_number1', 
                       password: 'password2', password_confirmation: 'password2',
                       current_password: 'password1'}}

  describe 'GET #new' do

    # TEST as a broker
    # TEST when a new supplier is submited
    # TEST then a message of success is sent
    describe 'as a broker' do
      before :each do
        sign_in(broker1)
      end

      it 'assigns a new supplier' do
        visit new_supplier_path
        expect(page).to have_xpath("//form[@action='/suppliers'
                                   and @method='post']")
        expect(page).to have_field({name: 'supplier[approved]'})
        fill_in('supplier[identifier]', :with => supplier_hash[:identifier])
        fill_in('supplier[email]', :with => supplier_hash[:email])
        fill_in('supplier[entreprise_name]',
                :with => supplier_hash[:entreprise_name])
        fill_in('supplier[tin]', :with => supplier_hash[:tin])
        fill_in('supplier[street_and_number]',
                :with => supplier_hash[:street_and_number])
        fill_in('supplier[city]', :with => supplier_hash[:city])
        fill_in('supplier[postal_code]', :with => supplier_hash[:postal_code])
        fill_in('supplier[state]', :with => supplier_hash[:state])
        fill_in('supplier[country]', :with => supplier_hash[:country])
        fill_in('supplier[telephone_number1]',
                :with => supplier_hash[:telephone_number1])
        fill_in('supplier[telephone_number2]',
                :with => supplier_hash[:telephone_number2])
        fill_in('supplier[password]', :with => supplier_hash[:password])
        fill_in('supplier[password_confirmation]',
                :with => supplier_hash[:password])
        find('[name=commit]').click
        expect(page).to have_content(
          I18n.t('controllers.suppliers.successfully_created'))
        expect(page.current_url).to eq(
          'http://www.example.com/suppliers/' + Supplier.last.id.to_s)
      end
    end

  end
end
