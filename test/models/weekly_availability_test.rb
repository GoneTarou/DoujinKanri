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
end
