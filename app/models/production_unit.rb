class ProductionUnit < ApplicationRecord
  belongs_to :work

  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 999
            },
            uniqueness: { scope: :work_id }
end
