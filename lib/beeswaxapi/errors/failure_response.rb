module BeeswaxAPI
  module Errors
    class FailureResponse < BeeswaxAPIError
      attr_reader :errors

      def initialize(errors: [])
        @errors = errors
      end

      def to_s
        errors.join(', ')
      end
    end
  end
end
