module TenderLinesHelper
  def tender_lines_index_path(customer_id)
    if customer_signed_in?
      customer_tender_lines_path(customer_id)
    else
      tender_lines_path
    end
  end

  def tender_line_show_path(customer_id, tender_line)
    if customer_signed_in?
      customer_tender_line_path(customer_id, tender_line)
    else
      tender_line_path(tender_line)
    end
  end

  def tender_line_edit_path(customer_id, tender_line)
    if customer_signed_in?
      edit_customer_tender_line_path(customer_id, tender_line)
    else
      edit_tender_line_path(tender_line)
    end
  end

  def tender_line_new_path(customer_id)
    if customer_signed_in?
      new_customer_tender_line_path(customer_id)
    else
      new_tender_line_path
    end
  end

  def tender_line_form_hash(customer_id, tender_line)
    path = tender_line_show_path(customer_id, tender_line)
    method = tender_line.persisted? ? "patch" : "post"
    {url: path, model: tender_line, local: true, method: method}
  end

end
