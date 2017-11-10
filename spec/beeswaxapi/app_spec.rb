RSpec.describe BeeswaxAPI::App do
  %i[
    basic_auth cookie_auth cookie_file base_uri 
    user_name password logger
  ].each do |config|
    it "contains #{config} config option" do
      expect(described_class.settings).to include config
    end
  end

  it 'setups basic_auth configuration' do
    described_class.config.basic_auth = true
  end

  it 'setups cookie_auth configuration' do
    described_class.config.cookie_auth = true
  end

  it 'setups cookie_file configuration' do
    described_class.config.cookie_file = '/tmp/cookies.txt'
  end

  it 'setups base_uri configuration' do
    described_class.config.base_uri = 'https://sandbox.beeswax.api.com/rest'
  end

  it 'setups user_name configuration' do
    described_class.config.user_name = 'user@name.com'
  end

  it 'setups password configuration' do
    described_class.config.password = 'password'
  end

  it 'setups logger configuration' do
    described_class.config.logger = double
  end
end
