# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  role            :integer          default("0"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password
  enum role: [:user, :admin]

  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: { on: :create }, confirmation: true,
                       length: { in: 6..32 }, allow_nil: true
  validates :password_confirmation, presence: true, if: -> { password.present? }

  def available_tasks
    return Task.all if admin?
    Task.by_user(self)
  end
end
