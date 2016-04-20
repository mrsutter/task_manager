class ApplicationController < ActionController::Base
  include AuthHelper
  include FlashHelper

  protect_from_forgery with: :exception

  private

  def per_page
    Settings.pagination.try(controller_name).try(action_name) ||
      Settings.pagination.default
  end
end
