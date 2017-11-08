require 'beeswaxapi/request'

module BeeswaxAPI
  class Endpoint
    extend Request

    class << self
      # attr_reader :path
      
      def path(value)
        @path = value
      end
    end
  end
end
