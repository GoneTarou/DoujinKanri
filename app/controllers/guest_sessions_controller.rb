class GuestSessionsController < ApplicationController
  def create
    if user_signed_in?
      redirect_to root_path
      return
    end

    user = User.create!(provider: nil, uid: nil)

    sign_in(:user, user, remember: true)

    redirect_to root_path, notice: "ゲストとして開始しました。"
  end
end
