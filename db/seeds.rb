Broker.create(identifier: 'broker1', email: 'pascal.carrie@gmail.com',
              password: 'passwordi83') unless Broker.find_by_identifier('broker1')
Supplier.create(identifier: 'supplier1', entreprise_name: "customer entreprise",
                email: 'pascal.carrie@google.com', currency: 'euro',
                unit_type: 'kilogram', password: 'passwordi83',
                approved: true, tin: "B000000001", country: "france") unless
 Supplier.find_by_identifier('supplier1')
Customer.create(identifier: 'customer1', email: 'pascal.carrie@google.com',
                password: 'passwordi83', currency: 'euro', unit_type: 'kilogram',
                approved: true, tin: "B000000001",
                entreprise_name: "customer entreprise", country: "france") unless
 Customer.find_by_identifier('customer1')
