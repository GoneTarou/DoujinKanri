require "test_helper"

class WorkTest < ActiveSupport::TestCase
  def build_work(attributes = {})
    defaults = {
      user: users(:one),
      title: "新しい漫画",
      work_type: "manga",
      total_quantity: 10,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    }

    Work.new(defaults.merge(attributes))
  end

  test "有効な作品を作成できる" do
    work = build_work

    assert_predicate work, :valid?
  end

  test "作品はUserに紐付く" do
    work = build_work

    assert_equal users(:one), work.user
  end

  test "作品種別は漫画を指定できる" do
    work = build_work(work_type: "manga")

    assert_predicate work, :valid?
  end

  test "作品種別は小説を指定できる" do
    work = build_work(work_type: "novel")

    assert_predicate work, :valid?
  end

  test "作品種別はイラストを指定できる" do
    work = build_work(work_type: "illustration")

    assert_predicate work, :valid?
  end

  test "未対応の作品種別は無効である" do
    work = build_work(work_type: "game")

    assert_not work.valid?
    assert work.errors[:work_type].present?
  end

  test "総量が0の場合は無効である" do
    work = build_work(total_quantity: 0)

    assert_not work.valid?
    assert work.errors[:total_quantity].present?
  end

  test "総量が1000の場合は無効である" do
    work = build_work(total_quantity: 1000)

    assert_not work.valid?
    assert work.errors[:total_quantity].present?
  end

  test "作品名が空の場合は無効である" do
    work = build_work(title: "")

    assert_not work.valid?
    assert work.errors[:title].present?
  end

  test "開始日が未設定の場合は無効である" do
    work = build_work(start_date: nil)

    assert_not work.valid?
    assert work.errors[:start_date].present?
  end

  test "締切が未設定の場合は無効である" do
    work = build_work(deadline: nil)

    assert_not work.valid?
    assert work.errors[:deadline].present?
  end

  test "締切が開始日より前の場合は無効である" do
    work = build_work(
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 10, 23)
    )

    assert_not work.valid?
    assert work.errors[:deadline].present?
  end
end
