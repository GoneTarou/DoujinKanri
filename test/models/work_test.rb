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

  test "漫画を作成すると標準工程が順番に作成される" do
    work = Work.create!(
      user: users(:one),
      title: "新しい漫画",
      work_type: "manga",
      total_quantity: 10,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    )

    assert_equal [ "ネーム", "下書き", "ペン入れ", "仕上げ" ],
                work.work_processes.order(:position).pluck(:name)
  end

  test "小説を作成すると標準工程が順番に作成される" do
    work = build_work(
      title: "新しい小説",
      work_type: "novel"
    )
    work.save!

    assert_equal [ "プロット", "本文", "推敲", "最終確認" ],
                work.work_processes.pluck(:name)
  end

  test "イラストを作成すると標準工程が順番に作成される" do
    work = build_work(
      title: "新しいイラスト",
      work_type: "illustration"
    )
    work.save!

    assert_equal [ "ラフ", "下書き", "線画", "色塗り", "仕上げ" ],
                work.work_processes.pluck(:name)
  end

  test "作品を作成すると総量分の制作対象が順番に作成される" do
    work = build_work(total_quantity: 3)
    work.save!

    assert_equal [ 1, 2, 3 ],
                work.production_units.order(:position).pluck(:position)
  end
end
