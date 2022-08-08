RSpec.describe BeeswaxAPI::Request do
  class BeeswaxAPI::Demo < BeeswaxAPI::Endpoint
  end

  context 'when missing auth_strategy' do
    before do
      BeeswaxAPI::App.configure do |c|
        c.auth_strategy = 'something else'
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

    context "v1" do
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
          expect(response.success).to be true
          expect(response.code).to be 200
        end
      end
    end

    context "v2" do
      before do
        response = Typhoeus::Response.new(code: 200, body: fixture)
        Typhoeus.stub('www.example.com/v2/something').and_return(response)
      end

      class BeeswaxAPI::Demo2 < BeeswaxAPI::Endpoint
        path :"v2/something"
      end
      context 'get request' do
        let(:fixture) { File.read("./spec/fixtures/api_response_v2_list.json") }

        it 'return response' do
          response = BeeswaxAPI::Demo2.retrieve
          expect(response.payload).not_to be_empty
        end
      end
    end
  end

  context 'unauthorized request' do
    before do
      BeeswaxAPI::App.configure do |c|
        c.base_uri = "www.example.com"
      end
      response = Typhoeus::Response.new(code: 401, body: fixture)
      Typhoeus.stub('www.example.com/').and_return(response)
    end

    let(:fixture) {
      "{
        \"success\": false,
        \"message\": \"Request not processed, API error\",
        \"errors\": [
          \"ERROR: User cannot be authenticated\"
        ]
      }"
    }

    it 'returns response' do
      response = BeeswaxAPI::Demo.retrieve
      expect(response.success).to be false
      expect(response.code).to be 401
      expect(response).to be_unauthorized
    end
  end

  context 'bad request' do
    before do
      BeeswaxAPI::App.configure do |c|
        c.base_uri = "www.example.com"
      end
      response = Typhoeus::Response.new(code: 400, body: fixture)
      Typhoeus.stub('www.example.com/').and_return(response)
    end

    let(:fixture) {
      "{
        \"success\": false,
        \"message\": \"Request not processed, API error\",
        \"errors\": [
          \"ERROR: User cannot be authenticated\"
        ]
      }"
    }

    context "raise_exception_on_bad_response is false" do
      context 'get request' do

        it 'returns response' do
          response = BeeswaxAPI::Demo.retrieve
          expect(response.success).to be false
          expect(response.code).to be 400
        end
      end
    end

    context "raise_exception_on_bad_response is true" do
      before do
        BeeswaxAPI::App.configure do |c|
          c.raise_exception_on_bad_response = true
        end
      end
      context 'get request' do

        it 'raises an error' do
          expect { BeeswaxAPI::Demo.retrieve }.to raise_error(BeeswaxAPI::Errors::FailureResponse)
        end
      end
    end
  end
end
