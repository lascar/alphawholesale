module OffersHelper

  def offer_show_path(offer)
    if supplier_signed_in?
      supplier_offer_path(current_supplier.id, offer)
    else
      offer_path(offer)
    end
  end

  def offer_edit_path(offer)
    if supplier_signed_in?
      edit_supplier_offer_path(current_supplier.id, offer)
    else
      edit_offer_path(offer)
    end
  end

  def offer_new_path
    if supplier_signed_in?
      new_supplier_offer_path(current_supplier.id)
    else
      new_offer_path
    end
  end

  def offer_form_hash(supplier_id, offer)
    if offer.id.nil?
      path = supplier_signed_in? ?
       supplier_offers_path(offer.id, supplier_id: supplier_id) :
       offers_path({id: offer.id})
    else
      path = supplier_signed_in? ?
        "/suppliers/" + supplier_id.to_s + "/offers/" + offer.id.to_s :
        "/offers/" + offer.id.to_s
    end
    method = offer.persisted? ? "patch" : "post"
    {url: path, model: offer, local: true, method: method}
  end

end
