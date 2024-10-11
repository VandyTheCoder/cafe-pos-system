module ApplicationHelper
  def menu_active?(controller_name)
    controller.controller_name == controller_name ? 'active' : ''
  end

  def render_sale_status(sale, style)
    content_tag(:span, sale.status, class: "#{get_sale_status_span_class(sale)}", style: "#{style}")
  end

  def get_sale_status_span_class(sale)
    if sale.pending?
      'badge bg-secondary rounded-3 fw-semibold'
    elsif sale.in_progress?
      'badge bg-warning rounded-3 fw-semibold'
    elsif sale.completed?
      'badge bg-success rounded-3 fw-semibold'
    elsif sale.canceled?
      'badge bg-danger rounded-3 fw-semibold'
    end
  end
end
