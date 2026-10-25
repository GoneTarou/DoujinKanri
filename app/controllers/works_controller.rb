class WorksController < ApplicationController
  before_action :require_user
  before_action :set_work, only: :show

  def index
    @works = current_user.works
  end

  def new
    @work = current_user.works.build
  end

  def create
    @work = current_user.works.build(work_params)

    if @work.save
      redirect_to @work, notice: "作品を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def require_user
    return if user_signed_in?

    redirect_to root_path
  end

  def set_work
    @work = current_user.works.find(params[:id])
  end

  def work_params
    params.require(:work).permit(
      :title,
      :work_type,
      :total_quantity,
      :start_date,
      :deadline
    )
  end
end
