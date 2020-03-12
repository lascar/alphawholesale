class CustomerMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = root_url
    mail(to: @user.email, subject: I18n.t('mails.welcome.subject'))
  end

  def offer_update
    @email = params[:email]
    @offer = params[:offer]
    mail(to: @email, subject: I18n.t('mails.offer_update.subject'))
  end
end
