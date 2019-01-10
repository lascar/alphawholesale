require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe "GET #index" do
    # TEST as a guest user
    # TEST when the list of orders is asked for
    # TEST then the root page is returned
    # TEST and a message of unauthenticated is send
    describe "as guest user" do
      before :each do
        get :index
      end

      it "returns the root page and returns a non authenticated message" do
        expect(response.redirect_url).to eq("http://test.host/")
        expect(flash.alert).to match(
         I18n.t('devise.failure.unauthenticated'))
      end
    end
  end
end
