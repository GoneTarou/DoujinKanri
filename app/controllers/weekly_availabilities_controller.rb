class WeeklyAvailabilitiesController < ApplicationController
  before_action :require_user
  before_action :set_work

  def index
    @weekly_availabilities = @work.weekly_availabilities.order(:weekday)
    @weekly_total = @weekly_availabilities.sum(:hours)
  end

  private

  def require_user
    return if user_signed_in?

    redirect_to root_path
  end

  def set_work
    @work = current_user.works.find(params[:work_id])
  end
end
