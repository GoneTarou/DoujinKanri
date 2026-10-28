class WorkProcessesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work

  def create
    @work_process = @work.work_processes.build(work_process_params)

    if @work_process.save
      redirect_to @work, notice: "工程を追加しました。"
    else
      redirect_to @work, alert: @work_process.errors.full_messages.to_sentence
    end
  end

  private

  def set_work
    @work = current_user.works.find(params[:work_id])
  end

  def work_process_params
    params.require(:work_process).permit(:name, :position)
  end
end
