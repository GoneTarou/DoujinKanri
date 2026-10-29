require "test_helper"

class WeeklyAvailabilityTest < ActiveSupport::TestCase
  def create_work
    Work.create!(
      user: users(:one),
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 1,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    )
  end

  test "有効な曜日別作業可能時間を作成できる" do
    weekly_availability = WeeklyAvailability.new(
      work: create_work,
      weekday: 0,
      hours: 4
    )

    assert_predicate weekly_availability, :valid?
  end

  test "作業可能時間が24時間を超える予定は無効である" do
    weekly_availability = WeeklyAvailability.new(
      work: create_work,
      weekday: 0,
      hours: 25
    )

    assert_not weekly_availability.valid?
  end

  test "曜日が7の予定は無効である" do
    weekly_availability = WeeklyAvailability.new(
      work: create_work,
      weekday: 7,
      hours: 4
    )

    assert_not weekly_availability.valid?
  end

  test "同じ作品に同じ曜日の予定は作成できない" do
    work = create_work
    WeeklyAvailability.create!(work: work, weekday: 0, hours: 4)

    duplicate = WeeklyAvailability.new(
      work: work,
      weekday: 0,
      hours: 6
    )

    assert_not duplicate.valid?
  end

  test "週合計を月曜日から順に均等配分できる" do
    assert_equal(
      {
        0 => 2,
        1 => 2,
        2 => 2,
        3 => 2,
        4 => 2,
        5 => 1,
        6 => 1
      },
      WeeklyAvailability.distribute_hours(12)
    )
  end

  test "週合計が0時間なら全曜日を0時間に配分する" do
    assert_equal(
      {
        0 => 0,
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0,
        6 => 0
      },
      WeeklyAvailability.distribute_hours(0)
    )
  end

test "週合計が168時間なら全曜日を24時間に配分する" do
    assert_equal(
      {
        0 => 24,
        1 => 24,
        2 => 24,
        3 => 24,
        4 => 24,
        5 => 24,
        6 => 24
      },
      WeeklyAvailability.distribute_hours(168)
    )
  end
end
