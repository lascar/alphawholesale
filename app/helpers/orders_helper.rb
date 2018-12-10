module OrdersHelper
  def orders_index_path(customer_id)
    if customer_signed_in?
      customer_orders_path(customer_id)
    else
      orders_path
    end
  end

  def order_show_path(customer_id, order)
    if customer_signed_in?
      customer_order_path(customer_id, order)
    else
      order_path(order)
    end
  end

  def order_edit_path(customer_id, order)
    if customer_signed_in?
      edit_customer_order_path(customer_id, order)
    else
      edit_order_path(order)
    end
  end

  def order_new_path(customer_id)
    if customer_signed_in?
      new_customer_order_path(customer_id)
    else
      new_order_path
    end
  end

  def order_form_hash(order)
    if order.persisted?
      path = customer_signed_in? ?
        "/customers/" + current_customer.id.to_s + "/orders/" + order.id.to_s :
        "/orders/" + order.id.to_s
    else
      path = customer_signed_in? ?
       customer_orders_path(order.id, customer_id: current_customer.id) :
       orders_path({id: order.id})
    end
    method = order.persisted? ? "patch" : "post"
    {url: path, model: order, local: true, method: method}
  end

end
