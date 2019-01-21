module TendersHelper
  def tenders_index_path
    if customer_signed_in?
      customer_tenders_path(current_customer.id)
    else
      tenders_path
    end
  end

  def tender_show_path(tender)
    if customer_signed_in?
      customer_tender_path(current_customer.id, tender)
    else
      tender_path(tender)
    end
  end

  def tender_edit_path(customer_id, tender)
    if customer_signed_in?
      edit_customer_tender_path(customer_id, tender)
    else
      edit_tender_path(tender)
    end
  end

  def tender_new_path(customer_id)
    if customer_signed_in?
      new_customer_tender_path(customer_id)
    else
      new_tender_path
    end
  end

  def tender_form_hash(customer_id, tender)
    path = tender_show_path(customer_id, tender)
    method = tender.persisted? ? "patch" : "post"
    {url: path, model: tender, local: true, method: method}
  end

end
