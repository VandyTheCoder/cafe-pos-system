class Sale < ApplicationRecord
  before_create :generate_code

  belongs_to :user, optional: true

  STATUS = ["Pending", "In Progress", "Canceled", "Completed"]

  scope :code_like, -> (value) { where('code iLIKE ?', "%#{value.squish}%") }

  private
    def generate_code
      self.code = "SAL#{SecureRandom.hex(4).upcase}-#{Time.now.strftime('%Y%m%d%H%M%S')}"
    end
end
