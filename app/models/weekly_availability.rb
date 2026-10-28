class WeeklyAvailability < ApplicationRecord
  belongs_to :work

  validates :hours,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 24
            }

  validates :weekday,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 6
            }

  validates :weekday, uniqueness: { scope: :work_id }
end
