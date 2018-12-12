require 'rails_helper'

RSpec.describe "Suppliers Feature", type: :feature do
  let!(:customer1) {create(:customer)}
  let!(:supplier1) {create(:supplier)}
  let(:broker1) {create(:broker)}

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

    # TEST as a customer
    # TEST when supplier is asked for new
    # TEST then a message of not authorized is sent
    # TEST and the customer's page is rendered
    describe "as a logged customer" do

      it "renders the customer's page with an unauthorized message" do
        sign_in(customer1)
        visit new_supplier_registration_url
        expect(page).to have_content(I18n.t('devise.errors.messages.not_authorized'))
        expect(page.current_path).to eq('/customers/' + customer1.id.to_s)
      end
    end

    # TEST as a supplier
    # TEST when supplier is asked for new
    # TEST then a message of not authorized is sent
    # TEST and the supplier's page is rendered
    describe "as a logged supplier" do

      it "renders the supplier's page with an unauthorized message" do
        sign_in(supplier1)
        visit new_supplier_registration_url
        expect(page).to have_content(I18n.t('devise.failure.already_authenticated'))
        expect(page.current_path).to eq('/suppliers/' + supplier1.id.to_s)
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
      end
    end
  end
end
