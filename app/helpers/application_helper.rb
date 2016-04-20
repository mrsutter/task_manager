module ApplicationHelper
  def bootstrap_class(flash_type)
    bootstrap_classes = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }
    bootstrap_classes.fetch(flash_type.to_sym)
  end
end
