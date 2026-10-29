class AvailabilitySetupsController < ApplicationController
  before_action :require_user
  before_action :set_work

  def new
  end

  def create
    unless weekly_total_valid?
      @error_message = "週合計は0〜168時間で入力してください。"
      render :new, status: :unprocessable_entity
      return
    end

    WeeklyAvailability.transaction do
      WeeklyAvailability.distribute_hours(weekly_total).each do |weekday, hours|
        @work.weekly_availabilities.create!(
          weekday: weekday,
          hours: hours
        )
      end
    end

    redirect_to work_weekly_availabilities_path(@work)
  end

  private

  def require_user
    return if user_signed_in?

    redirect_to root_path
  end

  def set_work
    @work = current_user.works.find(params[:work_id])
  end

  def weekly_total
    @weekly_total ||= Integer(
      params.require(:availability_setup).fetch(:weekly_total),
      exception: false
    )
  end

  def weekly_total_valid?
    weekly_total&.between?(0, 168)
  end
end
