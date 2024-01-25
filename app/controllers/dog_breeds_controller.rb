# frozen_string_literal: true

# controller responsible for fetching a dog image.
class DogBreedsController < ApplicationController
  def index
    response = FetchDogImage.call(breed_name: params[:name])
    respond_to do |format|
      format.html { render 'index' }
      format.json do
        render json: {
            image: response.response["message"],
            error: response.response["status"] == "error" ? response.response["message"] : nil
        }
      end
    end
  end
end

