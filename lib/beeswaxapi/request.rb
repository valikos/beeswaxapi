require 'typhoeus'
require 'yajl'

module BeeswaxAPI
  module Request
    def retrieve(**opts)
      opts[:method] = :get
      request_for(**opts)
    end

    def create(**opts)
      opts[:method] = :post
      request_for(**opts)
    end

    def update(**opts)
      opts[:method] = :put
      request_for(**opts)
    end

    def delete(**opts)
      opts[:method] = :delete
      request_for(**opts)
    end

    private

    def request_for(**opts)
      # TODO: better url constructor
      target_url = [App.config.base_uri, @path].join('/')

      if opts.has_key? :path
        target_url = [target_url, opts.delete(:path)].join('/')
      end

      case App.config.auth_strategy
      when 'basic'
        userpwd = "#{App.config.user_name}:#{App.config.password}"
        opts[:userpwd] = userpwd
      when 'cookies'
        cookie_file_path = App.config.cookie_file

        if cookie_file_path.nil? || cookie_file_path.empty?
          fail(
            Errors::MissingConfiguration,
            "Path to cookies is missed. Please check configuration."
          )
        end

        opts = opts.merge(
          cookiefile: App.config.cookie_file,
          cookiejar: App.config.cookie_file
        )
      else
        fail(
          Errors::MissingConfiguration,
          "Authencation strategy can't be missed. Please check configuration."
        )
      end

      if opts.has_key? :body_params
        opts[:body] = Yajl.dump(opts.delete(:body_params))
      end

      request = Typhoeus::Request.new(target_url, opts)

      if App.config.logger
        App.config.logger.info before_request_log(target_url, opts)
      end

      request.on_complete do |response|
        if App.config.logger
          App.config.logger.info after_request_log(target_url, opts, response)
        end

        if response.success?
          return success_response_handler(response)
        elsif response.timed_out?
          return timed_out_response_handler(response)
        elsif response.code >= 400 && response.code < 500
          return failure_response_handler(response)
        elsif response.code >= 500 && response.code
          return failure_response_handler(response)
        end
      end

      request.run
    end

    # TODO: improve heredoc formatting
    def before_request_log(target_url, opts)
      <<-LOG
Start request #{opts[:method].upcase} #{target_url}
#{opts[:body] if opts[:body]}
      LOG
    end

    # TODO: improve heredoc formatting
    def after_request_log(target_url, opts, response)
      <<-LOG
Finish request #{opts[:method].upcase} #{target_url} with #{response.code}
#{response.body}
      LOG
    end

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
