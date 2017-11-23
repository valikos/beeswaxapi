module BeeswaxAPI
  class ReportQueue < Endpoint
    path :report_queue

    class << self
      def success_response_handler(origin_response)
        parsed_response_body = parsed_body(origin_response.body)

        # NOTE: get method returns document in body
        if origin_response.request.options[:method] == :get
          if parsed_response_body.is_a?(Array)
            Response.new(payload: parsed_response_body)
          else
            Response.new(parsed_response_body)
          end
        else
          Response.new(parsed_response_body)
        end
      end
    end
  end
end
