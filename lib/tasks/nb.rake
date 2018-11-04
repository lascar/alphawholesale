namespace :nb do
  desc "build the product list upon the product/fr.yml"
  task make_products: :environment do
    hash = YAML.load_file("config/locales/products/fr.yml")
    names = hash["fr"]["product"]["name"]
    names.each do |name,v|
      hash_varieties = hash["fr"]["product"]["variety"][name]
      hash_aspects = hash["fr"]["product"]["aspect"][name]
      hash_sizes = hash["fr"]["product"]["size"][name]
      hash_packagings = hash["fr"]["product"]["packaging"][name]
      varieties = hash_varieties ? hash_varieties.keys : ["none"]
      aspects = hash_aspects ? hash_aspects.keys : ["none"]
      sizes = hash_sizes ? hash_sizes.keys : ["none"]
      packagings = hash_packagings ? hash_packagings.keys : ["none"]
      count = 0
      product = Product.find_by_name(name)
      if !product
        product = Product.create(name: name, approved: true)
      end
      varieties.each do |variety_name|
        variety = Variety.find_by_name_and_product_id(variety_name, product.id)
        if !variety
          variety = Variety.create(name: variety_name, product_id: product.id,
                                 approved: true)
        end
        sizes.each do |size_name|
          size = Size.find_by_name_and_product_id(
           size_name, product.id)
          if !size
            Size.create(name: size_name,
                              product_id: product.id, approved: true)
          end
        end
        aspects.each do |aspect_name|
          aspect = Aspect.find_by_name_and_product_id(
           aspect_name, product.id)
          if !aspect
            Aspect.create(name: aspect_name,
                             product_id: product.id, approved: true)
          end
        end
        packagings.each do |packaging_name|
          packaging = Packaging.find_by_name_and_product_id(
          packaging_name, product.id)
          if !packaging
            packaging = Packaging.create(name: packaging_name,
                                             product_id: product.id,
                                             approved: true)
          end
        end
      end
    end
  end
end
