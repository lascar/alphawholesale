class SupplierMailer < ApplicationMailer
  def welcome_email(supplier)
    @user = supplier
    @url  = root_url
    mail(to: @user.email, subject: I18n.t('mails.welcome.subject'))
  end
end
