class TasksController < ApplicationController
  
  before_action :set_message, only:[:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @tasks = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'タスクの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def edit
  end

  def update

    if @tasks.update(task_params)
      flash[:success] = 'タスク は正常に更新されました'
      redirect_to @tasks
    else
      flash.now[:danger] = 'タスク は更新されませんでした'
      render :edit
    end
    
  end

  def destroy
    @tasks.destroy

    flash[:success] = 'タスク は正常に削除されました'
    redirect_back(fallback_location: root_path)
  end

  private
  
  def set_message
    @tasks = Task.find(params[:id])
  end

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end


  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end


