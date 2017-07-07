class Twh < ApplicationRecord
  has_many :pics, inverse_of: :twh
  belongs_to :area
  
  accepts_nested_attributes_for :pics, allow_destroy: true

end
