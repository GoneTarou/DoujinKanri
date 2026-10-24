require "test_helper"

class WorksControllerTest < ActionDispatch::IntegrationTest
  def sign_in_as_guest
    post guest_session_path

    User.order(:id).last
  end

  def work_attributes
    {
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 20,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    }
  end

  test "未ログインでは作品一覧を開けない" do
    get works_path

    assert_redirected_to root_path
  end

  test "ログイン済みのゲストは作品一覧を開ける" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    get works_path

    assert_response :success
    assert_select "h1", "作品一覧"
    assert_select "a", work.title
  end

  test "ログイン済みのゲストは作品を作成できる" do
    user = sign_in_as_guest

    assert_difference -> { Work.count }, 1 do
      post works_path, params: { work: work_attributes }
    end

    work = Work.order(:id).last

    assert_equal user, work.user
    assert_redirected_to work_path(work)
  end

  test "ログイン済みのゲストは自分の作品詳細を開ける" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    get work_path(work)

    assert_response :success
    assert_select "h1", work.title
  end

  test "他人の作品詳細は開けない" do
    sign_in_as_guest
    other_user = users(:one)
    work = Work.create!(work_attributes.merge(user: other_user))

    get work_path(work)

    assert_response :not_found
  end
end
