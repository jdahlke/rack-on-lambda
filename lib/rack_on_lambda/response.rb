# frozen_string_literal: true

module RackOnLambda
  class Response
    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = stringify_body(body)
    end

    def as_json(_options = {})
      {
        'statusCode' => @status,
        'headers' => @headers,
        'isBase64Encoded' => @base64_encoded,
        'body' => @body
      }
    end

    private

    def stringify_body(body)
      result = ''
      body.each { |chunk| result += chunk.to_s }

      if result.ascii_only?
        @base64_encoded = false
        result
      else
        @base64_encoded = true
        Base64.strict_encode64(result)
      end
    end
  end
end
