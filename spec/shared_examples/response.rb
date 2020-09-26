# frozen_string_literal: true

RSpec.shared_examples 'responds with a well-formatted response' do
  shared_examples 'responds with the right status code, headers, and body' do
    it 'responds with the right status code' do
      expect(subject['statusCode']).to eq(status)
    end

    it 'responds with the right headers' do
      expect(subject['headers']).to eq(headers)
    end

    it 'responds with the right body' do
      expected_body = if subject['isBase64Encoded']
                        Base64.strict_encode64(body)
                      else
                        body.to_s
                      end

      expect(subject['body']).to eq(expected_body)
    end
  end

  context 'without a header indicating binary content' do
    let(:body) { 'Hello, world!' }

    include_examples 'responds with the right status code, headers, and body'

    it 'does not encode the response body in base64' do
      expect(subject['isBase64Encoded']).to eq(false)
    end
  end

  context 'with a header indicating binary content' do
    let(:body) { SecureRandom.bytes(10) }

    before { headers['Content-Transfer-Encoding'] = 'BINARY' }

    include_examples 'responds with the right status code, headers, and body'

    it 'encodes the response body in base64' do
      expect(subject['isBase64Encoded']).to eq(true)
    end
  end

  context 'without a response body' do
    let(:body) { nil }

    include_examples 'responds with the right status code, headers, and body'
  end
end
