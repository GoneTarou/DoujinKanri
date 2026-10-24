class WorksController < ApplicationController
  before_action :require_user

  def index
    @works = current_user.works
  end

  private

  def require_user
    return if user_signed_in?

    redirect_to root_path
  end
end
