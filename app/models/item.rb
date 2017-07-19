class Item < ApplicationRecord
  has_many :parts, inverse_of: :item
  accepts_nested_attributes_for :parts, allow_destroy: true
  # has_many :terminal_fourths
  validates :name, presence: true, length: { maximum: 30 }, if: :can_validate?

  def can_validate?
    true
  end
end
