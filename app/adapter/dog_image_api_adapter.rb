# frozen_string_literal: true

# Adapter responsible for interacting with the Dog Image API.
require 'json'
require 'httparty'

class DogImageApiAdapter
  include HTTParty
  BASE_URL = 'https://dog.ceo/api/'.freeze

  attr_accessor :name

  def initialize(breed_name)
    @name = breed_name
  end

  def call
    begin
      response = self.class.get(BASE_URL + "breed/#{name}/images/random", {
          headers: headers
      })
      JSON.parse(response.body)
    rescue StandardError => e
      Rails.logger.error "Error fetching image: #{e.message}"
    end
  end

  private
  def headers
    {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
    }
  end
end
