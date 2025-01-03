class SalesGrid < BaseGrid
  scope do
    Sale.order(created_at: :desc)
  end

  filter(:status, :enum, select: -> { Sale::STATUS }) { |value| where(status: value) }
  filter(:code, :string) { |value| where("code iLIKE ?", "%#{value}%") }
  filter(:created_at_gt, :date, header: "Created From") { |value| where("created_at >= ?", value) }
  filter(:created_at_lt, :date, header: "Created To") { |value| where("created_at <= ?", value) }

  column(:status, html: true) do |record|
    render_sale_status(record, "")
  end
  column(:code)
  column(:amount) do |record|
    "$ #{record.amount}"
  end
  column(:total_items, header: "Items") do |record|
    "#{record.total_items} Item(s)"
  end
  column(:created_at) do |record|
    record.created_at.strftime("%d %b %Y %H:%M:%S")
  end
  column(:action, html: true) do |record|
    link_to record, class: "btn btn-outline-info btn-sm" do
      content_tag(:i, "", class: "ti ti-eye")
    end
  end
end
