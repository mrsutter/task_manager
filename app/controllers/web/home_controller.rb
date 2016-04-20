class Web::HomeController < Web::ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result
               .includes(:user)
               .page(params[:page])
               .per(per_page)
  end
end
