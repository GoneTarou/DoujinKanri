class WeeklyAvailability < ApplicationRecord
  belongs_to :work

  def self.distribute_hours(total_hours)
    base_hours, remainder = total_hours.divmod(7)

    (0..6).to_h do |weekday|
      hours = base_hours + (weekday < remainder ? 1 : 0)

      [ weekday, hours ]
    end
  end

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
