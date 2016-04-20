class Web::User::TasksController < Web::User::ApplicationController
  def index
    @q = available_tasks.ransack(params[:q])
    @q.sorts = 'id asc' if @q.sorts.empty?
    @tasks = @q.result
               .includes(:user)
               .page(params[:page])
               .per(per_page)
  end

  def show
    find_task
  end

  def new
    init_task
  end

  def create
    init_task
    if @task.update_attributes(task_params)
      redirect_to user_task_path(@task)
    else
      render :new
    end
  end

  def edit
    find_task
  end

  def update
    find_task

    if @task.update_attributes(task_params)
      redirect_to user_task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    find_task

    @task.destroy!
    redirect_to user_tasks_path
  end

  def change_state
    find_task
    @task.update_attributes(state: task_params[:state])
    respond_to do |format|
      format.json { render json: @task }
    end
  end

  private

  def available_tasks
    current_user.available_tasks
  end

  def init_task
    @task = Task.new(user: current_user)
  end

  def find_task
    @task ||= available_tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :state, :user_id, :file)
  end
end
