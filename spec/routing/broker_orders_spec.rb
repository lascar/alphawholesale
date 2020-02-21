require 'rails_helper'

# type controller for sign_in to work
RSpec.describe "routing to orders", type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}

  xit "does not routes /orders to orders#index" do
    expect(:get => "/orders").not_to be_routable
  end

  xit "does not routes get /suppliers/1/orders/1/edit to orders#edit" do
    sign_in(supplier1)
    expect(:get => "/suppliers/#{supplier1.id.to_s}/orders/1/edit").not_to be_routable
  end
end

