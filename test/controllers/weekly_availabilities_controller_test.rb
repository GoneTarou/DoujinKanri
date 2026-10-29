require "test_helper"

class WeeklyAvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  def sign_in_as_guest
    post guest_session_path

    User.order(:id).last
  end

  def work_attributes
    {
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 1,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    }
  end

  test "ログイン済みのゲストは曜日別予定の一覧を開ける" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    WeeklyAvailability.distribute_hours(12).each do |weekday, hours|
      work.weekly_availabilities.create!(weekday: weekday, hours: hours)
    end

    get work_weekly_availabilities_path(work)

    assert_response :success
    assert_select "h1", "作業可能時間"
    assert_select "p", "週合計：12時間"
    assert_select "td", "月曜日"
    assert_select "td", "日曜日"
    assert_select "a", { text: "編集", count: 7 }
  end
end
