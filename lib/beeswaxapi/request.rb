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
        body = opts.delete(:body_params)
        opts[:body] = Yajl.dump(body)
      elsif opts.has_key? :body_file
        # in case of uploading files we shouldn't convert it to JSON
        # BeeswaxAPI::HtmlAsset::Upload.create(body_file: {creative_content: @file}, path: create_id)
        opts[:body] = opts.delete(:body_file)
      end

      # critical for API v2
      opts[:headers] = {"Content-Type" => "application/json"}

      request = Typhoeus::Request.new(target_url, opts)

      if App.config.logger
        App.config.logger.info before_request_log(target_url, opts)
      end

      request.on_complete do |response|
        if App.config.logger
          App.config.logger.info after_request_log(target_url, opts, response)
        end

        if response.success?
          success_response_handler(body: response.body, code: response.code)
        elsif response.timed_out?
          timed_out_response_handler(body: response.body, code: response.code)
        elsif response.code >= 400 && response.code < 500
          failure_response_handler(body: response.body, code: response.code)
        elsif response.code >= 500
          failure_response_handler(body: response.body, code: response.code)
        else
          @response = Response.new(errors: ["No response received"], success: false)
          @response.expection = Errors::FailureResponse.new(errors: ["Response code is 0"])
        end
      end
      request.run
      fail @response.expection if @response.expection && App.config.raise_exception_on_bad_response
      @response
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

    def success_response_handler(body:, code:)
      body = parsed_body(body)
      response =
        if v2?
          if body[:results]
             {success: true, code: code, payload: body[:results]}
           else
             {success: true, code: code, payload: body}
           end
        else
          body.merge({code: code})
        end
      @response = Response.new(response)
    end

    def failure_response_handler(body:, code:)
      @response = Response.new(parsed_body(body).merge({code: code}))
      @response.expection =
        if code == 401
          Errors::UnauthorizedResponse.new(errors: @response.errors)
        else
          Errors::FailureResponse.new(errors: @response.errors)
        end
    end

    def timed_out_response_handler(code:)
      @response = Response.new(success: false, code: code)
      @response.expection = Errors::TimedOutRequest.new, 'Request skipped by time out'
    end
  end
end
