module OffersHelper

  def offers_index_path
    if supplier_signed_in?
      supplier_offers_path(current_supplier.id)
    else
      offers_path
    end
  end

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

end
