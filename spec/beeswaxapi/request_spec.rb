RSpec.describe BeeswaxAPI::Request do
  context 'when missing auth_strategy' do
    before do
      BeeswaxAPI::App.configure do |c|
        c.auth_strategy = 'something else'
      end

      class BeeswaxAPI::Demo < BeeswaxAPI::Endpoint
      end
    end

    after do
      BeeswaxAPI::App.configure do |c|
        c.auth_strategy = 'basic'
      end
    end

    it 'fails execution' do
      expect { BeeswaxAPI::Demo.retrieve }.to raise_error(
        BeeswaxAPI::Errors::MissingConfiguration,
        "Authencation strategy can't be missed. Please check configuration."
      )
    end
  end

  context 'when missing cookie_file' do
    before do
      BeeswaxAPI::App.configure do |c|
        c.auth_strategy = 'cookies'
      end

      class BeeswaxAPI::Demo < BeeswaxAPI::Endpoint
      end
    end

    after do
      BeeswaxAPI::App.configure do |c|
        c.auth_strategy = 'basic'
      end
    end

    it 'fails execution' do
      expect { BeeswaxAPI::Demo.retrieve }.to raise_error(
        BeeswaxAPI::Errors::MissingConfiguration,
        "Path to cookies is missed. Please check configuration."
      )
    end
  end
end
