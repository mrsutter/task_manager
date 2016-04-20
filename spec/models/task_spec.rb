RSpec.describe Task, type: :model do
  describe '.create' do
    it "can't create task without name" do
      expect { create(:task, name: nil) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
