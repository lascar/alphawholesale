# ../controllers/concerns/accessible.rb
module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected
  def check_user
    # request.path.match(/^\/suppliers/)
    user_type = request.path.match(/^\/(\w*)/)[1]
    if current_broker
      flash.clear
      # if you have rails_broker. You can redirect anywhere really
      # redirect_to(rails_broker.dashboard_path) && return
    elsif current_supplier
      flash.clear
      # The authenticated root path can be defined in your routes.rb in: devise_scope :user do...
      # redirect_to(authenticated_user_root_path) && return
    elsif current_customer
      flash.clear
      # The authenticated root path can be defined in your routes.rb in: devise_scope :user do...
      # redirect_to(authenticated_user_root_path) && return
    end
  end
end
