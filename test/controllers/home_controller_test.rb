require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "ログイン済みのゲストには作品一覧へのリンクを表示する" do
    post guest_session_path

    get root_path

    assert_select "a[href=?]", works_path, "作品一覧へ"
  end
end
