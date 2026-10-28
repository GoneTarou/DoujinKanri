class WorkProcess < ApplicationRecord
  belongs_to :work
  has_many :process_checks, dependent: :destroy

  before_destroy :ensure_not_last_process, prepend: true
  after_create :create_process_checks

  validates :name, presence: true
  validates :position,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 },
            uniqueness: { scope: :work_id }

  private

  def create_process_checks
    work.production_units.find_each do |production_unit|
      ProcessCheck.create!(
        production_unit: production_unit,
        work_process: self
      )
    end
  end

  def ensure_not_last_process
    return if work.work_processes.where.not(id: id).exists?

    errors.add(:base, "工程は1つ以上必要です")
    throw :abort
  end
end
