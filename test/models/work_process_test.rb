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
end
