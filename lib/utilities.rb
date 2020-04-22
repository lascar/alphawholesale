# for tools generals
module Utilities

  def verif_def_attach_prd (definition)
    product_def = definition[:product]
    variety_def = definition[:variety] || ""
    aspect_def = definition[:aspect] || ""
    packaging_def = definition[:packaging] || ""
    size_def = definition[:size] || ""
    caliber_def = definition[:caliber] || ""
    regexp = /^[0-9a-zA-Z_\- ]+$/
    product = product_def && product_def.match(regexp) && Product.find_by_name(product_def)
    product_name = product&.name
    variety = (product && variety_def.match(regexp) &&
               product.varieties.include?(variety_def)) ? variety_def : nil
    aspect = (product && aspect_def.match(regexp) &&
      product.aspects.include?(aspect_def)) ? aspect_def : nil
    packaging = (product && packaging_def.match(regexp) &&
      product.packagings.include?(packaging_def)) ? packaging_def : nil
    size = (product && size_def.match(regexp) &&
      product.sizes.include?(size_def)) ? size_def : nil
    caliber = (product && caliber_def.match(regexp) &&
      product.calibers.include?(caliber_def)) ? caliber_def : nil
    {product: product_name, variety: variety, aspect: aspect, packaging: packaging,
     size: size, caliber: caliber}
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
end
