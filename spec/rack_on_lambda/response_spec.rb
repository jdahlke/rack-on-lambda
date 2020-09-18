# frozen_string_literal: true

RSpec.describe RackOnLambda::Response do
  describe '#as_json' do
    include_examples 'responds with a well-formatted response' do
      let(:status) { 200 }
      let(:headers) do
        {
          'content-type' => 'text/plain'
        }
      end
      let(:body) { '' }
      let(:body_proxy) do
        Rack::BodyProxy.new([body]) do
        end
      end

      subject do
        instance = described_class.new(status, headers, body_proxy)
        instance.as_json
      end
    end
  end
end
