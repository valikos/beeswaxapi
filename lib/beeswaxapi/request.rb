require 'typhoeus'
require 'yajl'

module BeeswaxAPI
  module Request
    def retrieve(**opts, &block)
      opts[:method] = :get
      request_for(opts, &block)
    end

    def create(**opts, &block)
      opts[:method] = :post
      request_for(opts, &block)
    end

    def update(**opts, &block)
      opts[:method] = :put
      request_for(opts, &block)
    end

    def delete(**opts, &block)
      opts[:method] = :delete
      request_for(opts, &block)
    end
    
    def request_for(**opts)
      target_url = [App.config.base_uri, @path].join('/')

      # configure basic auth request
      if App.config.basic_auth
        userpwd = "#{App.config.user_name}:#{App.config.password}"
        opts[:userpwd] = userpwd
      end
      
      # configure cookie request
      if App.config.cookie_auth
        opts = opts.merge(
          cookiefile: App.config.cookie_file,    
          cookiejar: App.config.cookie_file
        )
      end

      if opts.has_key? :body_params
        opts[:body] = Yajl.dump(opts[:body_params])
        opts.delete :body_params
      end

      request = Typhoeus::Request.new(target_url, opts)
      
      request.on_complete do |response|
        if response.success?
          return success_response_handler(response)
        elsif response.timed_out?
          return timed_out_response_handler(response)
        elsif response.code >= 400 && response.code < 500
          return failure_response_handler(response)
        end
      end

      request.run
    end

    private

    def parsed_body(body)
      Yajl.load(body, symbolize_keys: true)
    end

    def success_response_handler(origin_response)
      Response.new(parsed_body(origin_response.body))
    end

    def failure_response_handler(origin_response)
      response = Response.new(parsed_body(origin_response.body))
      fail Errors::FailureResponse.new(errors: response.errors)
    end

    def timed_out_response_handler(origin_response)
      fail Errors::TimedOutRequest.new, 'Request skipped by time out'
    end
  end
end
