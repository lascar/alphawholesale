class WelcomeController < ApplicationController
  def home
  end

  def routing_error
    flash[:alert] = user_type.blank? ? I18n.t('controllers.unauthenticated') :
      I18n.t('controllers.action_not_allowed')
    redirect_to path_for(user: current_user, path: 'user')
  end
end
