# frozen_string_literal: true

module RackOnLambda
  module Handlers
    class RestApi
      def self.call(event:, context:, app:)
        adapter = Adapters::RestApi.new(event: event, context: context)
        status, headers, body = app.call(adapter.env)
        adapter.response(status, headers, body)
      end
    end
  end
end
