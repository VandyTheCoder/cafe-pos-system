class SalesGrid < BaseGrid

  scope do
    Sale
  end

  filter(:status, :enum, select: -> { Sale::STATUS }) { |value| where(status: value) }
  filter(:code, :string) { |value| where('code iLIKE ?', "%#{value}%") }
  filter(:created_at_gt, :date, header: "Created From") { |value| where("created_at >= ?", value) }
  filter(:created_at_lt, :date, header: "Created To") { |value| where("created_at <= ?", value) }

  column(:status, html: true) do |record|
    if record.pending?
      content_tag(:span, "Pending", class: "badge bg-secondary rounded-3 fw-semibold")
    elsif record.in_progress?
      content_tag(:span, "In Progress", class: "badge bg-warning rounded-3 fw-semibold")
    elsif record.canceled?
      content_tag(:span, "Canceled", class: "badge bg-danger rounded-3 fw-semibold")
    elsif record.completed?
      content_tag(:span, "Completed", class: "badge bg-success rounded-3 fw-semibold")
    end
  end
  column(:code)
  column(:amount) do |record|
    "$ #{record.amount}"
  end
  column(:total_items, header: "Items") do |record|
    "#{record.total_items} Item(s)"
  end
  column(:created_at) do |record|
    record.created_at.strftime('%d %b %Y %H:%M:%S')
  end
  column(:action, html: true) do |record|
    link_to record, class: "btn btn-outline-info btn-sm" do
      content_tag(:i, "", class: "ti ti-eye")
    end
  end
end
