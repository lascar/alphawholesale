module VarietiesHelper
  def list_varieties_path
    if supplier_signed_in?
      supplier_varieties_path(current_supplier)
    else
      varieties_path
    end
  end

  def helper_new_variety_path
    if supplier_signed_in?
      new_supplier_variety_path(current_supplier)
    else
      new_variety_path
    end
  end

  def helper_edit_variety_path
    if supplier_signed_in?
      edit_supplier_variety_path(current_supplier)
    else
      edit_variety_path
    end
  end
end
