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

  context 'successful request' do
    before do
      BeeswaxAPI::App.configure do |c|
        c.base_uri = "www.example.com"
      end
      response = Typhoeus::Response.new(code: 200, body: fixture)
      Typhoeus.stub('www.example.com/').and_return(response)
    end

    context 'get request' do
      let(:fixture) { File.read("./spec/fixtures/api_respons.json") }

      it 'return response' do
        response = BeeswaxAPI::Demo.retrieve
      end
    end

    context 'post request' do
      let(:fixture) { File.read("./spec/fixtures/post_response.json") }

      it 'return response' do
        response = BeeswaxAPI::Demo.create
      end
    end
  end
end
