class ProductSize < ApplicationRecord
  belongs_to :product
  has_many :product_sales, dependent: :nullify

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :size, presence: true, uniqueness: { scope: :product_id, message: "should be unique per product" }
end
