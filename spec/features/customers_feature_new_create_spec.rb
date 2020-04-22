require 'rails_helper'

# A new customer can be registred by guest user (but not approved)
# A customer can modify his own registration (but not approval or identity) if
# he provides his current password
RSpec.describe 'Customers Feature new', type: :feature do
  let(:broker1) {create(:broker)}
  let(:customer_hash) {{identifier: 'identifier', email: 'customer2@test.com',
                       tin: 'en', entreprise_name: 'star treck',
                       street_and_number: 'street_and_number', city: 'city',
                       code_postal: 'code_postal', country: 'spain', state: 'state',
                       telephone_number1: 'telephone_number1',
                       telephone_number2: 'telephone_number2',
                       password: 'password2', password_confirmation: 'password2',
                       current_password: 'password1'}}

  describe 'GET #new' do

    # TEST as a broker
    # TEST when a new customer is submited
    # TEST then a message of success is sent
    describe 'as a broker' do
      before :each do
        sign_in(broker1)
      end

      it 'assigns a new customer' do
        visit new_customer_path
        expect(page).to have_xpath("//form[@action='/customers'
                                   and @method='post']")
        expect(page).to have_field({name: 'customer[approved]'})
        fill_in('customer[identifier]', :with => customer_hash[:identifier])
        fill_in('customer[email]', :with => customer_hash[:email])
        fill_in('customer[entreprise_name]',
                :with => customer_hash[:entreprise_name])
        fill_in('customer[tin]', :with => customer_hash[:tin])
        fill_in('customer[street_and_number]',
                :with => customer_hash[:street_and_number])
        fill_in('customer[city]', :with => customer_hash[:city])
        fill_in('customer[postal_code]', :with => customer_hash[:postal_code])
        fill_in('customer[state]', :with => customer_hash[:state])
        fill_in('customer[country]', :with => customer_hash[:country])
        fill_in('customer[telephone_number1]',
                :with => customer_hash[:telephone_number1])
        fill_in('customer[telephone_number2]',
                :with => customer_hash[:telephone_number2])
        fill_in('customer[password]', :with => customer_hash[:password])
        fill_in('customer[password_confirmation]',
                :with => customer_hash[:password])
        find('[name=commit]').click
        expect(page).to have_content(
          I18n.t('controllers.customers.successfully_created'))
        expect(page.current_url).to eq(
          'http://www.example.com/customers/' + Customer.last.id.to_s)
      end
    end

  end
end
