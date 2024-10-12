class UsersGrid < BaseGrid
  scope do
    User
  end

  filter(:name, :string) do |value, scope|
    scope.name_like(value)
  end
  filter(:email, :string) do |value, scope|
    scope.email_like(value)
  end
  filter(:gender, :enum, select: User::GENDER)
  filter(:role, :enum, select: User::ROLES)

  column(:picture, html: true) do |record|
    image_tag record.picture_as_thumbnail, class: "img-thumbnail" if record.picture.attached?
  end
  column(:name)
  column(:email)
  column(:gender)
  column(:role)
  column(:actions, html: true) do |record|
    render "users/actions", user: record
  end
end
