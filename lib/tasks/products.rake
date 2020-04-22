namespace :products do
  desc "build the product list upon the product/en.yml"
  task make_products: :environment do
    hash = YAML.load_file("config/locales/products/en.yml")
    products = hash["en"]["products"]
    products.each do |product, variants|
      product_new = Product.find_or_create_by(name: product)
      assortments = product_new.assortments == {} ? {"varieties": [], "aspects": [], "packagings": [],
                                       "sizes": [], "calibers": []}
                                    : product_new.assortments
      product_new.assortments = assortments
      product_new.save
      varieties_old = product_new.assortments["varieties"]
      varieties_new = variants["varieties"].map do |variety_sym, variety_trad|
        dejavu = product_new.assortments["varieties"].include? variety_sym
        dejavu == true ? nil : variety_sym
      end.compact
      varieties = varieties_old + varieties_new
      aspects_old = product_new.assortments["aspects"]
      aspects_new = variants["aspects"].map do |aspect_sym, aspect_trad|
        dejavu = product_new.assortments["aspects"].include? aspect_sym
        dejavu == true ? nil : aspect_sym
      end.compact
      aspects = aspects_old + aspects_new
      packagings_old = product_new.assortments["packagings"]
      packagings_new = variants["packagings"].map do |packaging_sym, packaging_trad|
        dejavu = product_new.assortments["packagings"].include? packaging_sym
        dejavu == true ? nil : packaging_sym
      end.compact
      packagings = packagings_old + packagings_new
      sizes_old = product_new.assortments["sizes"]
      sizes_new = variants["sizes"].map do |size_sym, size_trad|
        dejavu = product_new.assortments["sizes"].include? size_sym
        dejavu == true ? nil : size_sym
      end.compact
      sizes = sizes_old + sizes_new
      calibers_old = product_new.assortments["calibers"]
      calibers_new = variants["calibers"].map do |caliber_sym, caliber_trad|
        dejavu = product_new.assortments["calibers"].include? caliber_sym
        dejavu == true ? nil : caliber_sym
      end.compact
      calibers = calibers_old + calibers_new
      product_new.assortments = {varieties: varieties, aspects: aspects,
                                 packagings: packagings, sizes: sizes,
                                 calibers: calibers}
      product_new.save
    end
  end

  desc "build an example concrete_products list, offers, order,
   attached to the first supplier and customer"
  task make_examples: :environment do
    hash = YAML.load_file("config/locales/products/en.yml")
    products = hash["en"]["products"]
    supplier = Supplier.first
    customer = Customer.first
    product1 = Product.first
    product2 = Product.first(2).last
    supplier.products = [product1, product2]
    supplier.save
    customer.products = [product1, product2]
    customer.save
    [product1, product2].each do |product|
      varieties_keys = hash["en"]["products"][product.name]["varieties"].keys
      aspects_keys = hash["en"]["products"][product.name]["aspects"].keys
      packagings_keys = hash["en"]["products"][product.name]["packagings"].keys
      sizes_keys = hash["en"]["products"][product.name]["sizes"].keys
      calibers_keys = hash["en"]["products"][product.name]["calibers"].keys
      (1..2).each do |index|
        concrete_product = ConcreteProduct.find_or_create_by(
          product: product.name, variety: varieties_keys[index], aspect: aspects_keys[index],
          packaging: packagings_keys[index], size: sizes_keys[index], caliber: calibers_keys[index])
        supplier.concrete_products << concrete_product
        customer.concrete_products << concrete_product
      end
    end
    concrete_product1 = ConcreteProduct.first
    offer1 = Offer.find_or_create_by(supplier_id: supplier.id, concrete_product_id: concrete_product1.id, quantity: 4, unit_price_supplier: 11.4, unit_price_broker: 12, localisation_supplier: "Granada", localisation_broker: "Salobreña", incoterm: "EXW", supplier_observation: "text", date_start: Time.now, date_end: Time.now + 5.years, approved: true)
    offer2 = Offer.find_or_create_by(supplier_id: supplier.id, concrete_product_id: concrete_product1.id, quantity: 5, unit_price_supplier: 11.4, unit_price_broker: 12, localisation_supplier: "Granada", localisation_broker: "Salobreña", incoterm: "EXW", supplier_observation: "text", date_start: Time.now, date_end: Time.now + 5.years, approved: true)
    Order.find_or_create_by(customer_id: customer.id, offer_id: offer1.id, customer_observation: "text", quantity: 3, approved: true)
  end
end
