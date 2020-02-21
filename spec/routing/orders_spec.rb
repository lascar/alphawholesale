require 'rails_helper'

# type controller for sign_in to work
RSpec.describe OrdersController, type: :controller do
  let(:supplier1) {create(:supplier)}
  let(:customer1) {create(:customer)}

  it "does not routes /orders to orders#index" do
    expect(:get => "/orders").not_to be_routable
  end

  it "does not routes /orders/1 to orders#show" do
    expect(:get => "/orders/1").not_to be_routable
  end

  it "does not routes /orders/new to orders#new" do
    expect(:get => "/orders/new").not_to be_routable
  end

  xit "does not routes get /suppliers/1/orders/new to orders#new" do
    sign_in(supplier1)
    expect(:get => "/suppliers/#{supplier1.id.to_s}/orders/new").not_to be_routable
  end

  it "does not routes get /orders/1/edit to orders#edit" do
    expect(:get => "/orders/1/edit").not_to be_routable
  end

  it "does not routes get /suppliers/1/orders/1/edit to orders#edit" do
    sign_in(supplier1)
    expect(:get => "/suppliers/#{supplier1.id.to_s}/orders/1/edit").not_to be_routable
  end

  it "does not routes post /orders to orders#create" do
    expect(:post => "/orders/new").not_to be_routable
  end

  it "does not routes post /suppliers/1/orders to orders#create" do
    sign_in(supplier1)
    expect(:post => "/suppliers/#{supplier1.id.to_s}/orders").not_to be_routable
  end

  xit "does not routes /suppliers/1/orders/new to orders#new" do
    sign_in(supplier1)
    expect(:get => "/suppliers/#{supplier1.id.to_s}/orders/new").not_to be_routable
  end

  it "does not routes /orders/1 to orders#update" do
    expect(:put => "/orders/1").not_to be_routable
  end

  it "does not routes /suppliers/1/orders/1 to orders#update" do
    sign_in(supplier1)
    expect(:put => "/suppliers/#{supplier1.id.to_s}/orders/1").not_to be_routable
  end

  it "does not routes delete /orders/1 to orders#destroy" do
    expect(:delete => "/orders/1").not_to be_routable
  end

  it "does not routes delete /orders/1 to orders#destroy" do
    sign_in(supplier1)
    expect(:delete => "/suppliers/#{supplier1.id.to_s}/orders/1").not_to be_routable
  end

end

