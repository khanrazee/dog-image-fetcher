# frozen_string_literal: true

# Interactor responsible for fetching a dog image.
class FetchDogImage
  include Interactor

  def call
    return unless context.breed_name

    response = adaptor.call
    context.response = response
  end

  private

  def adaptor
    DogImageApiAdapter.new(context.breed_name)
  end
end
