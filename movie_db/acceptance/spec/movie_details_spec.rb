require 'spec_helper'

describe 'movie details endpoint' do

  it 'should exist' do
    response = get('/movies/tt0462538.json')
    expect(response.code).to eq(200)
  end

  context 'fields' do

    it 'should return as expected' do
      response = get('/movies/tt0462538.json')
      body = JSON.parse(response.body)
      schema = schema(:movie_details)
      expect(JSON::Validator.validate(schema, body)).to be_truthy
    end

    it 'should display budget in dollars' do
      response = get('/movies/tt0462538.json')
      body = JSON.parse(response.body)
      expect(body['budget']).to match(/^\$[0-9]+/)
    end

  end

  context 'ratings' do

    it 'should return the average' do
      response = get('/movies/tt0462538.json')
      body = JSON.parse(response.body)
      expect(body['rating']).to be_between(0.5, 5.0)
    end

  end

end
