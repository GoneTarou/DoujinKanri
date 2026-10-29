class AvailabilitySetupsController < ApplicationController
  before_action :require_user
  before_action :set_work

  def new
  end

  def create
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
    params.require(:availability_setup).fetch(:weekly_total).to_i
  end
end
