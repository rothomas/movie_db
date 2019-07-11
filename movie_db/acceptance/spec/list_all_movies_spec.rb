# frozen_string_literal: true

require 'spec_helper'
require 'digest'

describe 'list all movies endpoint' do

  it 'should exist' do
    response = get('/movies')
    expect(response.code).to eq(200)
  end

  context 'pagination' do

    it 'should paginate at 50 movies per page' do
      10.times do |page|
        response = get("/movies?page=#{page+1}")
        body = JSON.parse(response.body)
        expect(body.size).to be_between(0, 50)
      end
    end

    it 'should change pages using page query parameter' do
      digests = []
      10.times do |page|
        response = get("/movies?page=#{page+1}")
        body = JSON.parse(response.body)
        digests << Digest::MD5.hexdigest(response.body)
      end
      expect(digests.uniq.size).to eq(digests.size)
    end

  end

  context 'fields' do

    it 'should be returned as expected' do
      response = get('/movies')
      body = JSON.parse(response.body)
      schema = schema(:list_all_movies)
      expect(JSON::Validator.validate(schema, body)).to be_truthy
    end

    it 'should display budget in dollars' do
      response = get('/movies')
      body = JSON.parse(response.body)
      body.each do |movie|
        expect(movie['budget']).to match(/^\$[0-9]+/)
      end
    end

  end

end
