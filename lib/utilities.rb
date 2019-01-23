# for tools generals
module Utilities
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
