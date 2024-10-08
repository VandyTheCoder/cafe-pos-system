class Product < ApplicationRecord
  belongs_to :category
  has_many :product_product_sizes, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :product_product_sizes, reject_if: :all_blank, allow_destroy: true

  has_one_attached :picture

  validates :name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: ["Active", "Inactive", "Out of Stock"] }
  validates :category, presence: true

  STATUS = ["Active", "Inactive", "Out of Stock"]

  scope :name_like, -> (value) { where('name iLIKE ?', "%#{value.squish}%") }

  def picture_as_thumbnail
    picture.variant(resize: '300x300').processed
  end
end
