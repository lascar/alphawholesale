module CustomersHelper
  def customers_index_path
    customers_path
  end

  def customer_show_path(customer)
    if customer_signed_in?
      customer_path(current_customer)
    else
      customer_path(customer)
    end
  end

  def path_edit_customer(customer=nil)
    if customer_signed_in?
      edit_customer_registration_path
    else
      edit_customer_path(customer)
    end
  end

  def customer_new_path
    new_customer_path
  end
end
