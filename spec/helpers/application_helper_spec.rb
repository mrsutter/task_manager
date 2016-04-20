describe ApplicationHelper do
  describe '.bootstrap_class' do
    it 'returns correct class for flash type' do
      expect(helper.bootstrap_class(:notice)).to eq('alert-info')
    end
  end
end
