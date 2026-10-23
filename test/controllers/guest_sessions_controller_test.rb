require "test_helper"

class GuestSessionsControllerTest < ActionDispatch::IntegrationTest
  test "ゲストユーザーを作成してトップページへ戻る" do
    assert_difference -> { User.count }, 1 do
      post guest_session_path
    end

    user = User.order(:created_at).last

    assert_nil user.provider
    assert_nil user.uid
    assert_redirected_to root_path
  end
end
