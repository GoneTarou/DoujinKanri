require "test_helper"

class ProcessChecksControllerTest < ActionDispatch::IntegrationTest
  def sign_in_as_guest
    post guest_session_path

    User.order(:id).last
  end

  def create_work(user:)
    Work.create!(
      user: user,
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 1,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    )
  end

  test "ログイン済みのゲストは自分の工程チェックを完了にできる" do
    user = sign_in_as_guest
    work = create_work(user: user)
    process_check = work.process_checks.first

    patch process_check_path(process_check),
          params: { process_check: { checked: true } }

    assert_redirected_to work_path(work)
    assert_predicate process_check.reload, :checked?
  end

  test "他人の工程チェックは更新できない" do
    sign_in_as_guest
    work = create_work(user: users(:one))
    process_check = work.process_checks.first

    patch process_check_path(process_check),
          params: { process_check: { checked: true } }

    assert_response :not_found
    assert_not process_check.reload.checked?
  end
end
