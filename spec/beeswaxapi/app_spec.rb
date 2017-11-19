RSpec.describe BeeswaxAPI::App do
  %i[
    auth_strategy cookie_file base_uri
    user_name password logger
  ].each do |config|
    it "contains #{config} config option" do
      expect(described_class.settings).to include config
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
  end
end
