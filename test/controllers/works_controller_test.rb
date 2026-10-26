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

  test "ログイン済みのゲストは作品作成フォームを開ける" do
    sign_in_as_guest

    get new_work_path

    assert_response :success
    assert_select "h1", "新しい作品を作成"
    assert_select "input[name='work[title]']"
    assert_select "select[name='work[work_type]']"
    assert_select "input[name='work[total_quantity]']"
    assert_select "input[name='work[start_date]']"
    assert_select "input[name='work[deadline]']"
  end

  test "作品作成に失敗した場合はフォームとエラーを表示する" do
    sign_in_as_guest

    assert_no_difference -> { Work.count } do
      post works_path, params: {
        work: work_attributes.merge(total_quantity: 0)
      }
    end

    assert_response :unprocessable_entity
    assert_select "h1", "新しい作品を作成"
    assert_select "[role='alert']"
  end

  test "ログイン済みのゲストは自分の作品の編集画面を開ける" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    get edit_work_path(work)

    assert_response :success
    assert_select "h1", "作品を編集"
    assert_select "input[name='work[title]'][value='冬コミ新刊']"
  end

  test "ログイン済みのゲストは自分の作品を更新できる" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    patch work_path(work), params: {
      work: {
        title: "冬コミ新刊 改訂版",
        total_quantity: 24
      }
    }

    assert_redirected_to work_path(work)

    work.reload
    assert_equal "冬コミ新刊 改訂版", work.title
    assert_equal 24, work.total_quantity
  end

  test "ログイン済みのゲストは自分の作品を削除できる" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    assert_difference -> { Work.count }, -1 do
      delete work_path(work)
    end

    assert_redirected_to works_path
  end

  test "他人の作品は削除できない" do
    sign_in_as_guest
    other_user = users(:one)
    work = Work.create!(work_attributes.merge(user: other_user))

    assert_no_difference -> { Work.count } do
      delete work_path(work)
    end

    assert_response :not_found
  end

  test "作品詳細に編集と削除の操作を表示する" do
    user = sign_in_as_guest
    work = Work.create!(work_attributes.merge(user: user))

    get work_path(work)

    assert_select "a[href='#{edit_work_path(work)}']", "編集"

    assert_select "form[action='#{work_path(work)}'][method='post']" do
      assert_select "input[name='_method'][value='delete']"
      assert_select "button[type='submit']", "削除"    end
  end

  test "作品作成フォームには新しい漫画という初期作品名を表示する" do
    sign_in_as_guest

    get new_work_path

    assert_select "input[name='work[title]'][value='新しい漫画']"
  end

  test "作品詳細に標準工程を表示する" do
    user = sign_in_as_guest

    work = Work.create!(
      user: user,
      title: "冬コミ新刊",
      work_type: "manga",
      total_quantity: 10,
      start_date: Date.new(2026, 10, 24),
      deadline: Date.new(2026, 12, 10)
    )

    get work_path(work)

    assert_response :success
    assert_select "h2", "工程"
    assert_select "ol li", "ネーム"
    assert_select "ol li", "下書き"
    assert_select "ol li", "ペン入れ"
    assert_select "ol li", "仕上げ"
  end
end
