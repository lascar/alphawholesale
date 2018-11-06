module OffersHelper
  def offers_index_path(supplier_id)
    if supplier_signed_in?
      supplier_offers_path(supplier_id)
    else
      offers_path
    end
  end

  def offer_show_path(supplier_id, offer)
    if supplier_signed_in?
      supplier_offer_path(supplier_id, offer)
    else
      offer_path(offer)
    end
  end

  def offer_edit_path(supplier_id, offer)
    if supplier_signed_in?
      edit_supplier_offer_path(supplier_id, offer)
    else
      edit_offer_path(offer)
    end
  end

  def offer_new_path(supplier_id)
    if supplier_signed_in?
      new_supplier_offer_path(supplier_id)
    else
      new_offer_path
    end
  end

  def offer_form_hash(supplier_id, offer)
    path = supplier_signed_in? ?
     supplier_offer_path(supplier_id) : offer_path({supplier_id: supplier_id})
    method = offer.persisted? ? "patch" : "post"
    {url: path, model: offer, local: true, method: method}
  end

end
