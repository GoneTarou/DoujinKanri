require "test_helper"

class WorkProcessTest < ActiveSupport::TestCase
  def build_work_process(attributes = {})
    defaults = {
      work: works(:one),
      name: "ネーム",
      position: 1
    }

    WorkProcess.new(defaults.merge(attributes))
  end

  def create_work
    Work.create!(
      user: users(:one),
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 2,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    )
  end

  test "有効な工程を作成できる" do
    work_process = build_work_process

    assert_predicate work_process, :valid?
  end

  test "工程名が空の場合は無効である" do
    work_process = build_work_process(name: "")

    assert_not work_process.valid?
    assert work_process.errors[:name].present?
  end

  test "順番が0の場合は無効である" do
    work_process = build_work_process(position: 0)

    assert_not work_process.valid?
    assert work_process.errors[:position].present?
  end

  test "順番が11の場合は無効である" do
    work_process = build_work_process(position: 11)

    assert_not work_process.valid?
    assert work_process.errors[:position].present?
  end

  test "同じ作品内で同じ順番の工程は無効である" do
    WorkProcess.create!(
      work: works(:one),
      name: "ネーム",
      position: 1
    )

    work_process = build_work_process(
      name: "下書き",
      position: 1
    )

    assert_not work_process.valid?
    assert work_process.errors[:position].present?
  end

  test "工程を追加すると全制作対象の工程チェックが作成される" do
    work = create_work

    assert_difference -> { work.work_processes.count }, 1 do
      assert_difference -> { work.process_checks.count }, 2 do
        work.work_processes.create!(
          name: "トーン",
          position: 5
        )
      end
    end
  end

  test "最後の工程は削除できない" do
    work = create_work

    work.work_processes.order(:position).limit(3).each(&:destroy!)

    last_process = work.work_processes.reload.sole

    assert_not last_process.destroy
    assert_includes last_process.errors[:base], "工程は1つ以上必要です"
  end
end
