module SuppliersHelper
  def path_edit_supplier(supplier=nil)
    if supplier_signed_in?
      edit_supplier_registration_path
    else
      edit_supplier_path(supplier)
    end
  end
end
