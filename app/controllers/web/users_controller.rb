class Web::UsersController < Web::ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    redirect_to user_tasks_path if signed_in?
    init_user
  end

  def create
    init_user
    if @user.update_attributes(user_params)
      sign_in(@user)
      redirect_to user_tasks_path
    else
      render :new
    end
  end

  private

  def init_user
    @user = User.new
  end

  def user_params
    params.require(:user).permit(:email, :password,
                                 :password_confirmation)
  end
end
