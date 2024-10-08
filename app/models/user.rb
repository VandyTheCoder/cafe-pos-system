class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_one_attached :picture

  validates :name, :gender, :role, presence: true

  has_many :sales, dependent: :nullify

  GENDER = ["Male", "Female"]
  ROLES = ["Admin", "User"]

  scope :name_like, -> (value) { where('name iLIKE ?', "%#{value.squish}%") }
  scope :email_like, -> (value) { where('email iLIKE ?', "%#{value.squish}%") }

  ROLES.each do |role_name|
    scope role_name.downcase, -> { where(role: role_name) }

    define_method "#{role_name.downcase.parameterize.underscore}?" do
      role == role_name
    end
  end

  def picture_as_thumbnail
    picture.variant(resize: '100x100').processed
  end

  def is_super_admin?
    email == "admin@cafepos.vandy"
  end
end
