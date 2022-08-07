class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = Task.all.order(created_at: :desc)
    if params[:sort_expired]
      @tasks = Task.all.order(deadline: :desc)
    end

    if params[:task].present?
      if task_params[:title] && task_params[:status]
        @tasks = Task.search_title(task_params[:title])
        @tasks = Task.search_status(task_params[:status])
      elsif task_params[:title] && task_params[:status].empty?
        @tasks = Task.search_title(task_params[:title])
      elsif task_params[:status]
        @tasks = Task.search_status(task_params[:status])
      end
    end
  end

  def show
  end

  def new
    if params[:back]
      @task = Task.new(task_params)
    else
      @task = Task.new
    end
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task), notice: "登録が完了しました"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
      redirect_to tasks_path, notice: "タスクを削除しました"
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status)
  end

end
