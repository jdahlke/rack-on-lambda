# frozen_string_literal: true

FactoryBot.define do
  factory :api_gateway_context, class: Hash do
    initialize_with { attributes }
  end

  factory :api_gateway_event, class: Hash do
    path { '/api/v1/mailing/1234' }
    resource { '/{__proxy+}' }
    httpMethod { 'GET' }
    headers do
      {
        'Accept-Encoding' => 'gzip, br, deflate',
        'Authorization' => 'Bearer foobarblubb',
        'Content-Length' => body.to_s.bytesize,
        'Content-Type' => 'text/plain',
        'Host' => 'foo.example.com',
        'X-Forwarded-Port' => '8443'
      }
    end
    multiValueHeaders do
      headers.transform_values { |value| Array(value) }
    end
    multiValueQueryStringParameters do
      {
        'foo': %w[foo],
        'bar': %w[bar baz],
        'top[nested][nested_value]': %w[value],
        'top[nested][nested_array][]': %w[1]
      }
    end
    queryStringParameters do
      multiValueQueryStringParameters.transform_values(&:first)
    end
    pathParameters do
      {
        __proxy: path
      }
    end
    stageVariables { nil }
    requestContext do
      {
        resourceId: nil,
        resourcePath: resource,
        httpMethod: httpMethod,
        extendedRequestId: nil,
        requestTime: nil,
        path: path,
        accountId: nil,
        protocol: 'HTTP/1.1',
        stage: 'test',
        domainPrefix: nil,
        requestTimeEpoch: Time.now.to_i * 1000,
        requestId: nil,
        identity: {
          cognitoIdentityPoolId: nil,
          accountId: nil,
          cognitoIdentityId: nil,
          caller: nil,
          sourceIp: '127.0.0.1',
          accessKey: nil,
          cognitoAuthenticationType: nil,
          cognitoAuthenticationProvider: nil,
          userArn: nil,
          userAgent: 'curl/7.54.0',
          user: nil
        },
        domainName: 'test.local',
        apiId: nil
      }
    end
    body do
      {
        data: {
          attributes: {}
        }
      }.to_json
    end
    isBase64Encoded { false }

    initialize_with { attributes.deep_stringify_keys }
  end
end
