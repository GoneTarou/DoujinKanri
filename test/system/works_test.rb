require "application_system_test_case"

class WorksTest < ApplicationSystemTestCase
  test "ゲストユーザーは作品を作成できる" do
    visit root_path
    click_button "ゲストとして始める"

    assert_text "ゲストとして利用中です"

    visit works_path

    assert_text "作品一覧"
    click_link "新しい作品を作成"

    fill_in "作品名", with: "冬コミ新刊"
    select "漫画", from: "作品種別"
    fill_in "総量", with: 20
    set_date_field("制作開始日", "2026-10-24")
    set_date_field("締切", "2026-12-10")

    assert_field "制作開始日", with: "2026-10-24"
    assert_field "締切", with: "2026-12-10"

    click_button "作品を作成する"

    assert_text "作品を作成しました。"
    assert_text "冬コミ新刊"
    assert_text "20"
  end

  private

  def set_date_field(label, value)
    field = find_field(label)

    page.execute_script(<<~JAVASCRIPT, field, value)
      arguments[0].value = arguments[1];
      arguments[0].dispatchEvent(new Event("input", { bubbles: true }));
      arguments[0].dispatchEvent(new Event("change", { bubbles: true }));
    JAVASCRIPT
  end
end
