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
