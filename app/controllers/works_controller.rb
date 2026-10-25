class WorksController < ApplicationController
  before_action :require_user
  before_action :set_work, only: [ :show, :edit, :update, :destroy ]
  def index
    @works = current_user.works
  end

  def new
    @work = current_user.works.build(
      work_type: "manga",
      title: "新しい漫画"
    )
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

  def edit
  end

  def update
    if @work.update(work_params)
      redirect_to @work, notice: "作品を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work.destroy!

    redirect_to works_path, notice: "作品を削除しました。"
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
