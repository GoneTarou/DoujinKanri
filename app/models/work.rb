class Work < ApplicationRecord
  belongs_to :user

  enum :work_type, {
    manga: "manga",
    novel: "novel",
    illustration: "illustration"
  }, validate: true

  validates :title, presence: true
  validates :total_quantity,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 999
            }
  validates :start_date, :deadline, presence: true

  validate :deadline_on_or_after_start_date

  private

  def deadline_on_or_after_start_date
    return if start_date.blank? || deadline.blank?
    return if deadline >= start_date

    errors.add(:deadline, "は開始日以降にしてください")
  end
end
