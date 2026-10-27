class ProcessCheck < ApplicationRecord
  belongs_to :production_unit
  belongs_to :work_process

  validates :production_unit_id,
            uniqueness: { scope: :work_process_id }

  validate :production_unit_and_work_process_belong_to_same_work

  private

  def production_unit_and_work_process_belong_to_same_work
    return if production_unit.blank? || work_process.blank?
    return if production_unit.work_id == work_process.work_id

    errors.add(:base, "制作対象と工程は同じ作品に属している必要があります")
  end
end
