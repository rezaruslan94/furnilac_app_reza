class Area < ApplicationRecord
  has_many :pics, inverse_of: :area
  belongs_to :employee
  belongs_to :division
  accepts_nested_attributes_for :pics, allow_destroy: true

 # reject_if: :reject_pics, 
# 
 # def reject_pics(attributes)
  #  attributes['pic_date'].blank? || attributes['qty'].blank? ||
  #  attributes['wh'].blank? && attributes['part_id'].blank?
 # end

  delegate :name, to: :employee, prefix: true, allow_nil: true
  delegate :name, :to => :division, prefix: true, :allow_nil => true
end
