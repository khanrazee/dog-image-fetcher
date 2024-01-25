# spec/dog_image_api_adapter_spec.rb
require 'rails_helper'

RSpec.describe DogImageApiAdapter, type: :class do
  describe '#call' do
    context 'when the API call is successful' do
      let(:breed_name) { 'labrador' }
      let(:adapter) { described_class.new(breed_name) }
      let(:response) { '{"status":"success","message":"https://example.com/dog.jpg"}' }

      it 'returns a hash with image data' do
        stub_request(:get, "#{DogImageApiAdapter::BASE_URL}breed/#{breed_name}/images/random")
            .with(headers: described_class.new(breed_name).send(:headers))
            .to_return(body: response )

        result = adapter.call

        expect(result['status']).to eq('success')
        expect(result['message']).to eq('https://example.com/dog.jpg')
      end
    end

    context 'when the API call fails' do
      let(:breed_name) { 'nonexistent_breed' }
      let(:adapter) { described_class.new(breed_name) }

      it 'logs an error and returns nil' do
        stub_request(:get, "#{DogImageApiAdapter::BASE_URL}breed/#{breed_name}/images/random")
            .with(headers: described_class.new(breed_name).send(:headers))
            .to_raise(StandardError.new('API error'))

        expect(Rails.logger).to receive(:error).with(/Error fetching image:/)
        result = adapter.call

        expect(result).to be_nil
      end
    end
  end
end
