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

    click_link "編集"

    fill_in "作品名", with: "冬コミ新刊 改訂版"

    click_button "作品を更新する"

    assert_text "作品を更新しました。"
    assert_text "冬コミ新刊 改訂版"

    accept_confirm "「冬コミ新刊 改訂版」を削除しますか？" do
      click_button "削除"
    end

    assert_text "作品を削除しました。"
    assert_text "まだ作品がありません。"
  end

  test "ゲストユーザーは工程チェックを完了と未完了に切り替えられる" do
    visit root_path
    click_button "ゲストとして始める"
    assert_text "ゲストとして利用中です"

    visit new_work_path
    fill_in "作品名", with: "工程チェック用の作品"
    fill_in "総量", with: 1
    set_date_field("制作開始日", "2026-10-24")
    set_date_field("締切", "2026-12-10")
    click_button "作品を作成する"

    assert_text "完成：0 / 1"
    assert_text "残り：1"
    assert_text "進捗率：0%"

    4.times do
      find_button("未完了", match: :first).click
    end

    assert_text "完成：1 / 1"
    assert_text "残り：0"
    assert_text "進捗率：100%"

    find_button("完了", match: :first).click

    assert_text "完成：0 / 1"
    assert_text "残り：1"
    assert_text "進捗率：0%"
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
