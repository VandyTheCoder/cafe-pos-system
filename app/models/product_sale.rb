class ProductSale < ApplicationRecord
  belongs_to :sale
  belongs_to :product_size, optional: true

  validates :price, :sugar_level, presence: true
end
