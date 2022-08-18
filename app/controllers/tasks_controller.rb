class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user, only: %i[new]

  def index

    @tasks = current_user.tasks.order(created_at: :desc)
    if params[:sort_expired]
      @tasks = current_user.tasks.order(deadline: :desc)
    end
    if params[:sort_priority]
      @tasks = current_user.tasks.order(priority: :desc)
    end
    
    if params[:task]
      if task_params[:title].present? && task_params[:status].present?
        @tasks = @tasks.title_status(task_params[:title], task_params[:status])
      elsif task_params[:title].present?
        @tasks = @tasks.search_title(task_params[:title])
      elsif task_params[:status].present?
        @tasks = @tasks.search_status(task_params[:status])
      elsif task_params[:label_id].present?
        task_ids = Labeling.where(label_id: task_params[:label_id]).pluck(:task_id)
        @tasks = Task.find(task_ids)
      end
    end
    @tasks = Kaminari.paginate_array(@tasks).page(params[:page])
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
    @task = current_user.tasks.build(task_params)
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
    params.require(:task).permit(:title, :content, :deadline, :status, :priority, :label_id, label_ids: [] )
  end

  def authenticate_user
    unless @user = current_user
      redirect_to tasks_path
    end
  end

end
