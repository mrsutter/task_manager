RSpec.describe User, type: :model do
  describe '.destroy' do
    let(:user) { create(:user, :with_task) }

    it 'destroys user tasks' do
      expect { user.destroy }.to change { Task.by_user(user).count }.by(-1)
    end
  end
end
