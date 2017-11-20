class Part < ApplicationRecord
  belongs_to :item
  has_many :pics
  # validates :norms, :format => { :with => /\A\d+(?:\.\d{0,3})?\z/ }, :numericality => {:greater_than => 0, :less_than => 10}

  # def self.select2(query)
  #   all.where(::Arel::Nodes::SqlLiteral.new('name').matches("%#{sanitize_sql_like(query.to_s.strip.downcase)}%"))
  # end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Part.create! row.to_hash
    end
  end

  def self.select2(query)
    all.where(arel_table[:number].matches("%#{sanitize_sql_like(query.to_s.strip.downcase)}%"))
  end

  validates :name, :number, :norms, presence: true, length: { maximum: 255 }, if: :can_validate?

  def can_validate?
    true
  end
end
