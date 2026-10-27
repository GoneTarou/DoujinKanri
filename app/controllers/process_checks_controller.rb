class ProcessChecksController < ApplicationController
  before_action :require_user

  def update
    process_check = current_user.process_checks.find(params[:id])

    process_check.update!(process_check_params)

    redirect_to work_path(process_check.production_unit.work)
  end

  private

  def require_user
    return if user_signed_in?

    redirect_to root_path
  end

  def process_check_params
    params.require(:process_check).permit(:checked)
  end
end
