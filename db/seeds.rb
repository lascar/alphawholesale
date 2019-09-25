Broker.create(identifier: 'broker1', email: 'pascal.carrie@gmail.com',
              password: 'passwordi83') unless Broker.find_by_identifier('broker1')
Supplier.create(identifier: 'supplier1', entreprise_name: "customer entreprise",
                email: 'pascal.carrie@semillasl.com', currency: 'euro',
                unit_type: 'kilogram', password: 'passwordi83',
                approved: true, tin: "B000000001", country: "france") unless
 Supplier.find_by_identifier('supplier1')
Customer.create(identifier: 'customer1', email: 'pascal.carrie@semillasl.com',
                password: 'passwordi83', currency: 'euro', unit_type: 'kilogram',
                approved: true, tin: "B000000001",
                entreprise_name: "customer entreprise", country: "france") unless
 Customer.find_by_identifier('customer1')
if Rails.env == "development" && Supplier.first.identifier == 'supplier1'
  if !Product.all.empty? and Offer.all.empty?
    (1..3).each do |i|
      Offer.create(supplier_id: Supplier.first.id, product_id: Product.first.id,
                   approved: true, quantity: 1000 + i, unit_price_supplier: 20 + i,
                   unit_price_broker: 25 + i,
                   localisation_supplier: 'localisation_supplier_' + i.to_s,
                   localisation_broker: 'localisation_broker_' + i.to_s,
                   incoterm: INCOTERMS[i], observation: "observation " + i.to_s,
                   date_start: Time.now, date_end: Time.now + 6.weeks)
    end
  end
end
