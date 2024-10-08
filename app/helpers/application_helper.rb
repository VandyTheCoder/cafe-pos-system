module ApplicationHelper
  def menu_active?(controller_name)
    controller.controller_name == controller_name ? 'active' : ''
  end
end
