class ProductProductSize < ApplicationRecord
  belongs_to :product
  belongs_to :product_size

  validates :price, presence: true, numericality: { greater_than: 0 }
end
