require 'spec_helper'

describe StatsController do
  describe 'GET /top_referrers' do

    it 'responds with json' do
      get :top_referrers, format: :json
      expect(response.content_type).to eq('application/json')
    end

    it 'responds with Visit#top_referrers_for_top_urls_for_days' do
      expect(Visit).to receive(:top_referrers_for_top_urls_for_days).and_return({correct: 'value'})

      get :top_referrers, format: :json
      expect(response.body).to eq("{\"correct\":\"value\"}")
    end

    it 'responds with 200' do
      get :top_referrers, format: :json
      expect(response.code).to eq("200")
    end

  end

  describe 'GET /top_urls' do
    it 'responds with json' do
      get :top_urls, format: :json
      expect(response.content_type).to eq('application/json')
    end

    it 'responds with Visit#pageviews_for_past_days' do
      expect(Visit).to receive(:pageviews_for_past_days).and_return({correct: 'value'})

      get :top_urls, format: :json
      expect(response.body).to eq("{\"correct\":\"value\"}")
    end

    it 'responds with 200' do
      get :top_urls, format: :json
      expect(response.code).to eq("200")
    end
  end
end
