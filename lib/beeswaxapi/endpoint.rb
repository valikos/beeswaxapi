require 'beeswaxapi/request'

module BeeswaxAPI
  class Endpoint
    extend Request

    class << self
      def path(value)
        @path = value
      end

      def v2?
        @path.to_s.include?("v2")
      end
    end
  end
end
