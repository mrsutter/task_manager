module TaskRepository
  extend ActiveSupport::Concern

  included do
    scope :by_user, ->(user) { where(user: user) }
  end
end
