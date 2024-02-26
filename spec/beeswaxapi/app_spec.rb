RSpec.describe BeeswaxAPI::App do
  describe 'config' do
    it 'contains all the config options' do
      expect(described_class.config.to_h.keys)
        .to match_array (%i[ auth_strategy cookie_file base_uri user_name password logger raise_exception_on_bad_response ])
    end
  end

  describe 'defaults' do
    it 'returns "basic" for auth_strategy' do
      expect(described_class.config.auth_strategy).to eq 'basic'
    end

    it 'returns nil for cookie_file' do
      expect(described_class.config.cookie_file).to eq nil
    end

    it 'returns nil for base_uri' do
      expect(described_class.config.base_uri).to eq nil
    end

    it 'returns nil for user_name' do
      expect(described_class.config.user_name).to eq nil
    end

    it 'returns nil for password' do
      expect(described_class.config.password).to eq nil
    end

    it 'returns nil for logger' do
      expect(described_class.config.logger).to eq nil
    end

    it 'returns false for raise_exception_on_bad_response' do
      expect(described_class.config.raise_exception_on_bad_response).to eq false
    end
  end
end
