class Employee < ApplicationRecord
  has_many :departments
  has_many :divisions
  has_many :areas

  validates :name, presence: true, length: { maximum: 30 }, if: :can_validate?

  def can_validate?
    true
  end

end
