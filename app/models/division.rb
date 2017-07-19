class Division < ApplicationRecord
  belongs_to :employee, optional: true
  belongs_to :department
  has_many :areas, inverse_of: :division
  accepts_nested_attributes_for :areas, allow_destroy: true

  delegate :name, to: :employee, prefix: true, allow_nil: true

  validates :name, :department_id, :employee_id, presence: true, length: { maximum: 30 }, if: :can_validate?

  def can_validate?
    true
  end
end
