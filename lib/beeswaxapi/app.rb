module BeeswaxAPI
  class App
    extend Dry::Configurable

    # auth_strategy:     set auth method for api
    #                    "basic" or "cookies"
    # cookie_file:       path where to store cookie
    # base_uri:          base url for api
    # user_name:         user email
    # password:          user password
    # logger:            inject logger

    setting :auth_strategy, default: 'basic'
    setting :cookie_file
    setting :base_uri
    setting :user_name
    setting :password
    setting :logger
  end
end
