class Work < ApplicationRecord
  DEFAULT_WORK_PROCESS_NAMES = {
    "manga" => [ "ネーム", "下書き", "ペン入れ", "仕上げ" ],
    "novel" => [ "プロット", "本文", "推敲", "最終確認" ],
    "illustration" => [ "ラフ", "下書き", "線画", "色塗り", "仕上げ" ]
  }.freeze

  belongs_to :user
  has_many :work_processes, -> { order(:position) }, dependent: :destroy
  has_many :production_units, -> { order(:position) }, dependent: :destroy
  has_many :process_checks, through: :production_units

  before_destroy :mark_as_destroying, prepend: true
  after_create :create_initial_records

  after_update :sync_production_units, if: :saved_change_to_total_quantity?

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

  def completed_quantity
    production_units.includes(:process_checks).count(&:completed?)
  end

  def remaining_quantity
    total_quantity - completed_quantity
  end

  def progress_percentage
    return 0 if total_quantity.zero?

    (completed_quantity * 100.0 / total_quantity).round
  end

  def destroying?
    @destroying
  end

  private

  def mark_as_destroying
    @destroying = true
  end

  def deadline_on_or_after_start_date
    return if start_date.blank? || deadline.blank?
    return if deadline >= start_date

    errors.add(:deadline, "は開始日以降にしてください")
  end

  def create_default_work_processes
    DEFAULT_WORK_PROCESS_NAMES.fetch(work_type).each_with_index do |name, index|
      work_processes.create!(
        name: name,
        position: index + 1
      )
    end
  end

  def create_production_units
    total_quantity.times do |index|
      production_units.create!(position: index + 1)
    end
  end

  def create_initial_records
    create_default_work_processes
    create_production_units
    create_process_checks
  end

  def create_process_checks
    production_units.each do |production_unit|
      create_process_checks_for(production_unit)
    end
  end

  def create_process_checks_for(production_unit)
    work_processes.each do |work_process|
      ProcessCheck.create!(
        production_unit: production_unit,
        work_process: work_process
      )
    end
  end

  def sync_production_units
    previous_quantity, current_quantity = saved_change_to_total_quantity

    if current_quantity > previous_quantity
      (previous_quantity + 1).upto(current_quantity) do |position|
        production_unit = production_units.create!(position: position)
        create_process_checks_for(production_unit)
      end
    else
      production_units.where("position > ?", current_quantity).destroy_all
    end
  end
end
