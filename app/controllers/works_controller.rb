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
    if quantity_reduction_requires_confirmation?
      prepare_quantity_reduction_confirmation
      render :confirm_quantity_reduction
    elsif @work.update(work_params)
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

  def quantity_reduction_requires_confirmation?
    return false if params[:confirm_quantity_reduction] == "true"

    new_total_quantity = work_params[:total_quantity].to_i

    new_total_quantity.positive? &&
      new_total_quantity < @work.total_quantity
  end

  def prepare_quantity_reduction_confirmation
    @pending_work_attributes = work_params.to_h
    @new_total_quantity = @pending_work_attributes.fetch("total_quantity").to_i
    @removed_production_units = @work.production_units.where(
      "position > ?",
      @new_total_quantity
    )
    @removed_process_check_count = ProcessCheck.where(
      production_unit: @removed_production_units
    ).count
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
