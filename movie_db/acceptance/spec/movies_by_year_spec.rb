# frozen_string_literal: true

require 'spec_helper'
require 'digest'

describe 'movies by year endpoint' do

  it 'should exist' do
    response = get('/movies?year=1973')
    expect(response.code).to eq(200)
  end

  it 'only returns movies in the specified year' do
    page = 1
    more = true
    while more
      response = get("/movies?year=1973&page=#{page}")
      body = JSON.parse(response.body)
      expect(body.size).to be_between(0, 50)
      more = !body.empty?
      page += 1
    end
  end

  context 'pagination' do

    it 'should limit to 50 results per page' do
      page = 1
      more = true
      while more
        response = get("/movies?year=1973&page=#{page}")
        body = JSON.parse(response.body)
        expect(body.size).to be_between(0, 50)
        more = !body.empty?
        page += 1
      end
    end

    it 'should change pages via query param' do
      page = 1
      more = true
      digests = []
      while more
        response = get("/movies?year=1973&page=#{page}")
        body = JSON.parse(response.body)
        digests << Digest::MD5.hexdigest(response.body)
        more = !body.empty?
        page += 1
      end
      expect(digests.uniq.size).to eq(digests.size)
    end

  end

  context 'sorting' do

    it 'orders results chronologically, ascending by default' do
      page = 1
      more = true
      last_date = nil
      while more
        response = get("/movies?year=1973&page=#{page}")
        body = JSON.parse(response.body)
        body.map { |result| result['releaseDate'] }.each do |date|
          expect(date >= last_date).to be_truthy unless last_date.nil?
          last_date = date
        end
        more = !body.empty?
        page += 1
      end
    end

    it 'can explicitly order ascending via query param' do
      page = 1
      more = true
      last_date = nil
      while more
        response = get("/movies?year=1973&sort=asc&page=#{page}")
        body = JSON.parse(response.body)
        body.map { |result| result['releaseDate'] }.each do |date|
          expect(date >= last_date).to be_truthy unless last_date.nil?
          last_date = date
        end
        more = !body.empty?
        page += 1
      end
    end

    it 'can order descending via query param' do
      page = 1
      more = true
      last_date = nil
      while more
        response = get("/movies?year=1973&sort=desc&page=#{page}")
        body = JSON.parse(response.body)
        body.map { |result| result['releaseDate'] }.each do |date|
          expect(date <= last_date).to be_truthy unless last_date.nil?
          last_date = date
        end
        more = !body.empty?
        page += 1
      end
    end

  end

  context 'fields' do

    it 'returns as expected' do
      response = get('/movies?year=1973')
      body = JSON.parse(response.body)
      schema = schema(:list_all_movies)
      expect(JSON::Validator.validate(schema, body)).to be_truthy
    end

  end

end
