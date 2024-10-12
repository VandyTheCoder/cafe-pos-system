class ProductsGrid < BaseGrid
  scope do
    Product.order(:created_at)
  end

  filter(:name, :string) { |value| where("name ilike ?", "%#{value}%") }
  filter(:status, :enum, select: Product::STATUS)
  filter(:category_id, :enum, select: -> { Category.pluck(:name, :id) })

  column(:id)
  column(:picture, html: true) do |record|
    image_tag record.picture_as_thumbnail, class: "img-thumbnail" if record.picture.attached?
  end
  column(:name)
  column(:status)
  column(:category, html: true) do |record|
    link_to record.category.name, record.category
  end
  column(:created_at) do |record|
    record.created_at.strftime("%B %d, %Y")
  end
  column(:actions, html: true) do |record|
    render "products/actions", product: record
  end
end
