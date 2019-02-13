# app/services/supplier_approval.rb

class SupplierApprovalService
  def initialize(supplier)
    @supplier = supplier
  end

  def approved
    if @supplier.approved
      SupplierMailer.with(user: @supplier).welcome_email.deliver_later
    end
  end
end

