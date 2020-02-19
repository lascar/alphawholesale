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
end
