module CustomersHelper
  def path_edit_customer(customer=nil)
    if customer_signed_in?
      edit_customer_registration_path
    else
      edit_customer_path(customer)
    end
  end
end
