module AuthHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    current_user.present?
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    redirect_to new_user_session_path unless signed_in?
  end

  def authenticate_admin!
    return true if signed_in? && current_user.admin?
    redirect_to new_user_session_path
  end
end
