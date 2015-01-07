class Cat < ActiveRecord::Base
  COLOR_OPTIONS = %w(white grey black tabby brown cream buff red calico)

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion:
    { in: COLOR_OPTIONS,
    message: "choose a valid color" } # %{value} WTF? str intrp vs. erb??
  validates :sex, inclusion: { in: %w(M F) }

  has_many :cat_rental_requests, :dependent => :destroy

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year -
      ((now.month > birth_date.month || (now.month == birth_date.month &&
      now.day >= birth_date.day)) ? 0 : 1)
  end
end
