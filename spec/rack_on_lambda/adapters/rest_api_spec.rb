# frozen_string_literal: true

RSpec.describe RackOnLambda::Adapters::RestApi do
  let(:context) { build(:api_gateway_context) }
  let(:event) { build(:api_gateway_event) }
  let(:instance) { described_class.new(context: context, event: event) }

  describe '#env' do
    subject(:env) { instance.env }

    context 'with a base64 encoded body' do
      let(:plain_text_body) { 'Hello, world!' }
      let(:event) do
        attributes = build(
          :api_gateway_event,
          body: Base64.encode64(plain_text_body),
          isBase64Encoded: true
        )
        attributes.deep_stringify_keys
      end

      it 'contains the request body' do
        expect(env['rack.input']).to be_a(StringIO)
        expect(env['rack.input'].read).to eq(plain_text_body)
      end
    end

    context 'with a plain text body' do
      it 'contains the request body' do
        expect(env['rack.input']).to be_a(StringIO)
        expect(env['rack.input'].read).to eq(event['body'].to_s)
      end
    end

    context 'with no body' do
      let(:event) { build(:api_gateway_event, body: nil) }

      it 'contains an empty request body' do
        expect(env['rack.input']).to be_a(StringIO)
        expect(env['rack.input'].read).to eq('')
      end
    end

    it 'contains all HTTP headers' do
      headers = event['headers'] || {}

      expect(env['CONTENT_TYPE']).to eq(headers['Content-Type'])
      expect(env['HTTP_ACCEPT_ENCODING']).to eq(headers['Accept-Encoding'])
      expect(env['HTTP_AUTHORIZATION']).to eq(headers['Authorization'])
    end

    it 'set the right "content-length" header' do
      expect(env['CONTENT_LENGTH']).to eq(event['body'].to_s.bytesize.to_s)
    end

    it 'contains the HTTP request method' do
      expect(env['REQUEST_METHOD']).to eq(event['httpMethod'])
    end

    it 'contains the HTTP request path' do
      expect(env['PATH_INFO']).to eq(event['path'])
    end

    it 'contains the query string' do
      expected_query_string = 'foo=foo&bar[]=bar&bar[]=baz&' \
                              'top%5Bnested%5D%5Bnested_value%5D=value&' \
                              'top%5Bnested%5D%5Bnested_array%5D[]=1'

      expect(env['QUERY_STRING']).to eq(expected_query_string)
    end

    it 'contains the server name' do
      expect(env['SERVER_NAME']).to eq(event['headers']['Host'])
    end

    it 'contains the server port' do
      expect(env['SERVER_PORT']).to eq(event['headers']['X-Forwarded-Port'])
    end

    it 'contains the URI schema' do
      expect(env['rack.url_scheme']).to eq('https')
    end
  end

  describe '#response' do
    include_examples 'responds with a well-formatted response' do
      let(:status) { 200 }
      let(:headers) { {} }
      let(:body) { '' }
      let(:body_proxy) do
        Rack::BodyProxy.new([body]) do
        end
      end

      subject do
        instance.response(status, headers, body_proxy)
      end
    end
  end
end
