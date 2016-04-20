class Web::Admin::UsersController < Web::Admin::ApplicationController
  before_action :prevent_modifying_himself!, only: [:edit]

  def index
    @q = User.ransack(params[:q])
    @q.sorts = 'id asc' if @q.sorts.empty?
    @users = @q.result
               .page(params[:page])
               .per(per_page)
  end

  def show
    find_user
  end

  def new
    init_user
  end

  def create
    init_user
    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    find_user

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    find_user

    @user.destroy!
    redirect_to admin_users_path
  end

  private

  def init_user
    @user = User.new
  end

  def find_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :role)
  end

  def prevent_modifying_himself!
    find_user
    return if @user != current_user
    flash[:error] = flash_translate(:modify_himself)
    redirect_to admin_users_path
  end
end
