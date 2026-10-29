require "test_helper"

class AvailabilitySetupsControllerTest < ActionDispatch::IntegrationTest
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

  test "週合計から7日分の作業可能時間を作成できる" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    assert_difference -> { work.weekly_availabilities.count }, 7 do
      post work_availability_setup_path(work), params: {
        availability_setup: { weekly_total: 12 }
      }
    end

    assert_redirected_to work_weekly_availabilities_path(work)
    assert_equal(
      [
        [ 0, 2 ],
        [ 1, 2 ],
        [ 2, 2 ],
        [ 3, 2 ],
        [ 4, 2 ],
        [ 5, 1 ],
        [ 6, 1 ]
      ],
      work.weekly_availabilities.order(:weekday).pluck(:weekday, :hours)
    )
  end
end
