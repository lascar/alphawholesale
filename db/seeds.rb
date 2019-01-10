# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Broker.create(identifier: 'broker1', email: 'pascal.carrie@gmail.com',
              password: 'milu2000') unless Broker.find_by_identifier('broker1')
Supplier.create(identifier: 'supplier1', entreprise_name: "customer entreprise",
                email: 'pascal.carrie@semillasl.com', currency: 'euro',
                unit_type: 'kilogram', password: 'milu2000',
                approved: true, tin: "B000000001", country: "france") unless
 Supplier.find_by_identifier('supplier1')
Customer.create(identifier: 'customer1', email: 'pascal.carrie@semillasl.com',
                password: 'milu2000', currency: 'euro', unit_type: 'kilogram',
                approved: true, tin: "B000000001",
                entreprise_name: "customer entreprise", country: "france") unless
 Customer.find_by_identifier('customer1')
if Rails.env == "development"
  if !Product.all.empty? and Offer.all.empty?
    (1..3).each do |i|
      Offer.create(supplier_id: Supplier.first.id, product_id: Product.first.id, approved: true, quantity: 1000 + i, unit_price_supplier: 20 + i, unit_price_broker: 25 + i, localisation_supplier: 'localisation_supplier_' + i.to_s, localisation_broker: 'localisation_broker_' + i.to_s, incoterm: INCOTERMS[i], observation: "observation " + i.to_s, date_start: Time.now, date_end: Time.now + 6.weeks)
    end
  end
end
