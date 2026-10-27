require "test_helper"

class ProcessCheckTest < ActiveSupport::TestCase
  def create_work(user: users(:one))
    Work.create!(
      user: user,
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 1,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    )
  end

  def build_process_check(work)
    ProcessCheck.new(
      production_unit: work.production_units.first,
      work_process: work.work_processes.first
    )
  end

  test "有効な工程チェックを作成できる" do
    process_check = build_process_check(create_work)

    assert_predicate process_check, :valid?
  end

  test "工程チェックは未完了で作成される" do
    process_check = build_process_check(create_work)

    assert_equal false, process_check.checked
  end

  test "同じ制作対象と工程の組み合わせは重複できない" do
    work = create_work
    process_check = build_process_check(work)
    process_check.save!

    duplicate_check = build_process_check(work)

    assert_not duplicate_check.valid?
    assert duplicate_check.errors[:production_unit_id].present?
  end

  test "別作品の制作対象と工程は組み合わせられない" do
    first_work = create_work
    second_work = create_work(user: users(:two))

    process_check = ProcessCheck.new(
      production_unit: first_work.production_units.first,
      work_process: second_work.work_processes.first
    )

    assert_not process_check.valid?
    assert process_check.errors[:base].present?
  end
end
