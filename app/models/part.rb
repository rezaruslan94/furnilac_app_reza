class Part < ApplicationRecord
  belongs_to :item
  has_many :pics
end
