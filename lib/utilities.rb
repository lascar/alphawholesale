# for tools generals
module Utilities
  def make_offers_new_products(products)
    product_names = products.map do |product|
      [product.name, product.id]
    end.uniq
    product_names.inject({}) do |products_hash, product_array|
      product_name = product_array.first
      product_id = product_array.last
      product =
      {"product_id" => product_id,
      "variety" =>
       products.select{|p| p.name == product_name}.first.varieties.map do |variety|
         [variety.name, variety.id]
       end,
      "aspects" =>
       products.select{|p| p.name == product_name}.first.aspects.map do |aspect|
        [aspect.name, aspect.id]
      end,
      "sizes" =>
       products.select{|p| p.name == product_name}.first.sizes.map do |size|
        [size.name, size.id]
      end,
      "packagings" =>
       products.select{|p| p.name == product_name}.first.packagings.map do |packaging|
        [packaging.name, packaging.id]
      end
      }
      products_hash[product_name] = product
      products_hash
    end
  end

  def put_currencies_unit_types
    currencies = CURRENCIES.map do |currency|
      currency_string = 'currencies.' + currency
      [I18n.t(currency_string + '.currency') +
       ' (' + I18n.t(currency_string + '.symbol') + ')',
       currency]
    end
    unit_types = UNIT_TYPES.map do |unit_type|
      unit_types_string = 'unit_types.' + unit_type
      [I18n.t(unit_types_string + '.unit_type') +
       ' (' + I18n.t(unit_types_string + '.symbol') + ')',
       unit_type]
    end
    return [currencies, unit_types]
  end

  def map_offers_for_index(offers)
    offers.map do |offer|
      {id: offer.id,
       product_name: offer.product.name + " " +
         (offer.variety ? offer.variety.name : ""),
       quantity: offer.quantity.to_s + ' ' +
         I18n.t('unit_types.' + offer.supplier.unit_type + '.symbol'),
       supplier_price: (offer.unit_price_supplier &&
               offer.supplier.currency ?
                (offer.unit_price_supplier.to_s + " " +
                 t("currencies." + offer.supplier.currency + ".symbol")) :
                 "-"),
       broker_price: (offer.unit_price_broker &&
               offer.supplier.currency ?
                (offer.unit_price_broker.to_s + " " +
                 t("currencies." + offer.supplier.currency + ".symbol")) :
                 "-")
      }
    end
  end

  def map_orders_for_index(orders)
    orders.map do |order|
      {id: order.id, product_name: order.offer.product.name,
       quantity: order.quantity.to_s + ' ' +
       I18n.t('unit_types.' + order.offer.supplier.unit_type + '.symbol')}
    end
  end

  def make_offer_nested(offer)
    {product_name: offer.product_name, variety_name: offer.variety_name,
     aspect_name: offer.aspect_name, packaging_name: offer.packaging_name,
    supplier_currency: offer.supplier_currency}
  end
end
