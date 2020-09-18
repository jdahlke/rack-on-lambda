# frozen_string_literal: true

RSpec.describe RackOnLambda::Handlers::RestApi do
  let(:status) { 200 }
  let(:headers) { {} }
  let(:body) { SecureRandom.hex(32) }

  let(:app) { ->(env) { [status, headers, env['rack.input'].dup] } }
  let(:context) { build(:api_gateway_context) }
  let(:event) { build(:api_gateway_event, body: body) }

  describe '.call' do
    subject(:response) do
      described_class.call(event: event, context: context, app: app)
    end

    it 'calls the app' do
      allow(app).to receive(:call).and_call_original
      subject
      expect(app).to have_received(:call)
    end

    include_examples 'responds with a well-formatted response'
  end
end
