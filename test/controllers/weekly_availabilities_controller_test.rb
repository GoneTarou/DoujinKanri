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

  test "ログイン済みのゲストは曜日別の作業可能時間を更新できる" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))
    weekly_availability = work.weekly_availabilities.create!(
      weekday: 5,
      hours: 1
    )

    patch work_weekly_availability_path(work, weekly_availability), params: {
      weekly_availability: { hours: 4 }
    }

    assert_redirected_to work_weekly_availabilities_path(work)
    assert_equal 4, weekly_availability.reload.hours
  end

  test "作業可能時間が24時間を超える場合は更新できない" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))
    weekly_availability = work.weekly_availabilities.create!(
      weekday: 5,
      hours: 1
    )

    patch work_weekly_availability_path(work, weekly_availability), params: {
      weekly_availability: { hours: 25 }
    }

    assert_response :unprocessable_entity
    assert_select "[role='alert']", "作業可能時間は0〜24時間で入力してください。"
    assert_equal 1, weekly_availability.reload.hours
  end

  test "ログイン済みのゲストは曜日別予定の編集画面を開ける" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))
    weekly_availability = work.weekly_availabilities.create!(
      weekday: 5,
      hours: 1
    )

    get edit_work_weekly_availability_path(work, weekly_availability)

    assert_response :success
    assert_select "h1", "土曜日の作業可能時間"
    assert_select "input[name='weekly_availability[hours]'][value='1']"
  end
end
