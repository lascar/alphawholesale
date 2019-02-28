require 'rails_helper'

RSpec.describe SupplierMailer, type: :mailer do
  describe 'welcome' do
    let(:supplier1) {build(:supplier)}
    let(:mail) {described_class.welcome_email(supplier1)}

    it 'renders the subject' do
      expect(mail.subject).to eq I18n.t('mails.welcome.subject')
    end

    it "sent to the supplier's email" do
      expect(mail.to).to eq [supplier1.email]
    end
  end
end
