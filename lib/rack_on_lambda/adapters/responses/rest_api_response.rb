# frozen_string_literal: true

module RackOnLambda
  module Adapters
    module Responses
      class RestApiResponse
        def initialize(status, headers, body)
          @status = status
          @headers = headers
          @body = stringify_body(body)
        end

        def as_json(_options = {})
          {
            'statusCode' => status,
            'headers' => headers,
            'isBase64Encoded' => base64_encoded?,
            'body' => body
          }
        end

        private

        attr_reader :status, :headers, :body

        def base64_encoded?
          return @base64_encoded if defined?(@base64_encoded)

          encoding = canonical_headers.fetch('content-transfer-encoding', '')
          @base64_encoded = encoding.casecmp('binary').zero?
        end

        def canonical_headers
          @canonical_headers ||= headers.transform_keys do |key|
            key.to_s.downcase
          end
        end

        def stringify_body(body)
          result = ''
          body.each { |chunk| result += chunk.to_s }

          base64_encoded? ? Base64.strict_encode64(result) : result
        end
      end
    end
  end
end
