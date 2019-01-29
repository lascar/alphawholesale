module AspectsHelper
  def list_aspects_path
    if supplier_signed_in?
      supplier_aspects_path(current_supplier)
    else
      aspects_path
    end
  end

  def helper_show_aspect_path
    if supplier_signed_in?
      supplier_aspect_path(@aspect, supplier_id: current_supplier.id)
    else
      aspect_path(@aspect)
    end
  end

  def helper_new_aspect_path
    if supplier_signed_in?
      new_supplier_aspect_path(current_supplier)
    else
      new_aspect_path
    end
  end

  def helper_edit_aspect_path
    if supplier_signed_in?
      edit_supplier_aspect_path(current_supplier)
    else
      edit_aspect_path
    end
  end
end
