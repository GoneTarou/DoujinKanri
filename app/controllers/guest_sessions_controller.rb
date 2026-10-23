class GuestSessionsController < ApplicationController
  def create
    user = User.create!

    sign_in(:user, user, remember: true)

    redirect_to root_path, notice: "ゲストとして開始しました。"
  end
end
