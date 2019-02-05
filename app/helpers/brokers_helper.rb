module BrokersHelper

  def brokers_index_path
    brokers_path
  end

  def broker_show_path
    broker_path(current_broker)
  end

  def broker_edit_path
    edit_broker_path(current_broker)
  end

  def broker_new_path
    new_broker_path
  end
end
