# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  state       :string           not null
#  description :text
#  file        :string
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Task < ActiveRecord::Base
  include AASM
  include TaskRepository
  mount_uploader :file, TaskFileUploader

  belongs_to :user

  validates :user, presence: :true
  validates :name, presence: :true

  aasm column: :state, initial: :new do
    state :new
    state :started
    state :finished

    event :start do
      transitions from: [:new, :finished], to: :started
    end

    event :finish do
      transitions from: [:new, :started], to: :finished
    end
  end

  def file_is_image?
    file.content_type.try(:start_with?, 'image')
  end
end
