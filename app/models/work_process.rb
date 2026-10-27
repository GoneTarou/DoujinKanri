class WorkProcess < ApplicationRecord
  belongs_to :work
  has_many :process_checks, dependent: :destroy

  validates :name, presence: true
  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 10
            },
            uniqueness: { scope: :work_id }
end
