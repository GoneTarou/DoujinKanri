class Work < ApplicationRecord
  DEFAULT_WORK_PROCESS_NAMES = {
    "manga" => [ "ネーム", "下書き", "ペン入れ", "仕上げ" ],
    "novel" => [ "プロット", "本文", "推敲", "最終確認" ],
    "illustration" => [ "ラフ", "下書き", "線画", "色塗り", "仕上げ" ]
  }.freeze

  belongs_to :user
  has_many :work_processes, -> { order(:position) }, dependent: :destroy
  has_many :production_units, -> { order(:position) }, dependent: :destroy

  after_create :create_default_work_processes
  after_create :create_production_units

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
end
