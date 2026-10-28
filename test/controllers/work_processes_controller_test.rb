require "test_helper"

class WorkProcessesControllerTest < ActionDispatch::IntegrationTest
  def sign_in_as_guest
    post guest_session_path

    User.order(:id).last
  end

  def work_attributes
    {
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 2,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    }
  end

  test "ログイン済みのゲストは自分の作品に工程を追加できる" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    assert_difference -> { WorkProcess.count }, 1 do
      post work_work_processes_path(work), params: {
        work_process: {
          name: "トーン",
          position: 5
        }
      }
    end

    added_process = work.work_processes.order(:position).last

    assert_equal "トーン", added_process.name
    assert_equal 5, added_process.position
    assert_equal work.production_units.count, added_process.process_checks.count
    assert_redirected_to work_path(work)
  end

  test "ログイン済みのゲストは自分の作品の工程を削除できる" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))
    work_process = work.work_processes.find_by!(position: 4)

    assert_difference -> { WorkProcess.count }, -1 do
      delete work_work_process_path(work, work_process)
    end

    assert_redirected_to work_path(work)
    assert_equal 3, work.work_processes.reload.count
    assert_equal 6, work.process_checks.count
  end
end
