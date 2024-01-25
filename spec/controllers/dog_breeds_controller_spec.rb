# spec/controllers/dog_breeds_controller_spec.rb
require 'rails_helper'

RSpec.describe DogBreedsController, type: :controller do
  describe 'GET #index' do
    context 'when breed_name is provided' do
      let(:breed_name) { 'labrador' }

      it 'renders the index template for HTML format' do
        allow(FetchDogImage).to receive(:call).with(breed_name: breed_name).and_return(double(success?: true, response: { 'status' => 'success', 'message' => 'https://example.com/dog.jpg' }))

        get :index, params: { name: breed_name }
        expect(response).to render_template('index')
      end

      it 'renders JSON with the image information for JSON format' do
        allow(FetchDogImage).to receive(:call).with(breed_name: breed_name).and_return(double(success?: true, response: { 'status' => 'success', 'message' => 'https://example.com/dog.jpg' }))

        get :index, params: { name: breed_name }, format: :json

        json_response = JSON.parse(response.body)
        expect(json_response['image']).to eq('https://example.com/dog.jpg')
        expect(json_response['error']).to be_nil
      end
    end

    context 'when breed_name is not provided' do
      it 'renders the index template for HTML format' do
        get :index
        expect(response).to render_template('index')
      end

      it 'renders JSON with error information for JSON format' do
        allow(FetchDogImage).to receive(:call).and_return(double(success?: false, response: { 'status' => 'error', 'message' => 'Breed not provided' }))

        get :index, format: :json

        json_response = JSON.parse(response.body)
        expect(json_response['image']).to eq('Breed not provided')
        expect(json_response['error']).to eq('Breed not provided')
      end
    end
  end
end
