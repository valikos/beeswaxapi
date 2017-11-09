module BeeswaxAPI
  class App
    extend Dry::Configurable

    # basic_auth:        turns on basic auth for client
    # cookie_auth:       turns cookies auth for client
    # cookie_file:       path where to store cookie
    # base_uri:          base url for api
    # user_name:         user email
    # password:          user password
    # verbose_logger:    turns on verbose logs from curl

    setting :basic_auth, false 
    setting :cookie_auth, false
    setting :cookie_file
    setting :base_uri
    setting :user_name
    setting :password
    setting :verbose_logger, false
  end
end
