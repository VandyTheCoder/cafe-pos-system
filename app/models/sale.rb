class Sale < ApplicationRecord
  before_create :generate_code

  belongs_to :user, optional: true
  has_many :product_sales, dependent: :destroy

  STATUS = ["Pending", "In Progress", "Canceled", "Completed"]

  scope :code_like, -> (value) { where('code iLIKE ?', "%#{value.squish}%") }

  STATUS.each do |status_name|
    scope status_name.downcase, -> { where(status: status_name) }

    define_method "#{status_name.downcase.parameterize.underscore}?" do
      status == status_name
    end
  end

  private
    def generate_code
      self.code = "#{SecureRandom.hex(4).upcase}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
    end
end
