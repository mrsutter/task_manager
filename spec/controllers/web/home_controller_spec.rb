describe Web::HomeController, type: :controller do
  describe '#index' do
    before do
      create(:user, :with_tasks)
    end

    it 'returns success' do
      get :index
      expect(response).to be_ok
    end
  end
end
