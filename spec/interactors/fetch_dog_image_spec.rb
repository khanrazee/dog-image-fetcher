# spec/interactors/fetch_dog_image_spec.rb
require 'rails_helper'

RSpec.describe FetchDogImage, type: :interactor do
  describe '.call' do
    context 'when breed_name is provided' do
      let(:breed_name) { 'labrador' }
      let(:context) { Interactor::Context.new(breed_name: breed_name) }

      it 'calls DogImageApiAdapter and sets response in context' do
        dog_image_adapter_instance = instance_double(DogImageApiAdapter,
                         call: { 'status' => 'success', 'message' => 'https://example.com/dog.jpg' })

        allow(DogImageApiAdapter).to receive(:new).with(breed_name).and_return(dog_image_adapter_instance)

        result = described_class.call(context)

        expect(result).to be_success
        expect(result.response).to eq({ 'status' => 'success', 'message' => 'https://example.com/dog.jpg' })
        expect(DogImageApiAdapter).to have_received(:new).with(breed_name)
      end
    end

    context 'when breed_name is not provided' do
      let(:context) { Interactor::Context.new }

      it 'does not call DogImageApiAdapter' do
        result = described_class.call(context)

        expect(result).to be_success
        expect(result.response).to be_nil
      end
    end
  end
end
