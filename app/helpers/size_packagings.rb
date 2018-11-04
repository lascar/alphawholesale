module PackagingsHelper
  def list_packagings_path
    if supplier_signed_in?
      supplier_packagings_path(current_supplier)
    else
      packagings_path
    end
  end

end
