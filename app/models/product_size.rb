class ProductSize < ApplicationRecord
  has_many :product_product_sizes, dependent: :destroy
  has_many :product_sales, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :size, presence: true
  validates :capacity, presence: true
end
