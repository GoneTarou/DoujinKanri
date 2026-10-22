require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "トップページを表示できる" do
    visit root_path

    assert_text "しめきりノート"
    assert_text "ゲストとして始める"
    assert_text "Googleでログイン"
  end
end
