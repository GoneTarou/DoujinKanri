class WeeklyAvailabilitiesController < ApplicationController
  before_action :require_user
  before_action :set_work

  def index
    @weekly_availabilities = @work.weekly_availabilities.order(:weekday)
    @weekly_total = @weekly_availabilities.sum(:hours)
  end

  def edit
    @weekly_availability = @work.weekly_availabilities.find(params[:id])
  end

  def update
    @weekly_availability = @work.weekly_availabilities.find(params[:id])

    if @weekly_availability.update(weekly_availability_params)
      redirect_to work_weekly_availabilities_path(@work),
                  notice: "作業可能時間を更新しました。"
    else
      @error_message = "作業可能時間は0〜24時間で入力してください。"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_user
    return if user_signed_in?

    redirect_to root_path
  end

  def set_work
    @work = current_user.works.find(params[:work_id])
  end

  def weekly_availability_params
    params.require(:weekly_availability).permit(:hours)
  end
end
