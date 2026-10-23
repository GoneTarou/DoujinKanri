require "test_helper"

class GuestSessionsControllerTest < ActionDispatch::IntegrationTest
  test "ゲストユーザーを作成してログインする" do
    assert_difference -> { User.count }, 1 do
      post guest_session_path
    end

    user = User.order(:id).last

    assert_nil user.provider
    assert_nil user.uid
    assert_redirected_to root_path

    follow_redirect!

    assert_select "p", "ゲストとして利用中です"
    assert_select ".alert", "ゲストとして開始しました。"
  end
end
