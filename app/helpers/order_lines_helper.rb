module OrderLinesHelper
  def order_lines_index_path(customer_id)
    if customer_signed_in?
      customer_order_lines_path(customer_id)
    else
      order_lines_path
    end
  end

  def order_line_show_path(customer_id, order_line)
    if customer_signed_in?
      customer_order_line_path(customer_id, order_line)
    else
      order_line_path(order_line)
    end
  end

  def order_line_edit_path(customer_id, order_line)
    if customer_signed_in?
      edit_customer_order_line_path(customer_id, order_line)
    else
      edit_order_line_path(order_line)
    end
  end

  def order_line_new_path(customer_id)
    if customer_signed_in?
      new_customer_order_line_path(customer_id)
    else
      new_order_line_path
    end
  end

  def order_line_form_hash(customer_id, order_line)
    path = order_line_show_path(customer_id, order_line)
    method = order_line.persisted? ? "patch" : "post"
    {url: path, model: order_line, local: true, method: method}
  end

end
