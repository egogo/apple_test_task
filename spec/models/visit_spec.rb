require 'spec_helper'

describe Visit do

  before {
    Timecop.freeze(Time.parse('2013-12-03'))

    10.times { Visit.insert({url: 'http://apple.com', created_at: Time.now}) }
    12.times { Visit.insert({url: 'http://opensource.org', referrer: 'http://en.wikipedia.org', created_at: Time.now}) }
    4.times { Visit.insert({url: 'https://apple.com', created_at: Time.now}) }
    30.times { Visit.insert({url: 'http://developer.apple.com', created_at: Time.now-1.day}) }
    3.times { Visit.insert({url: 'http://en.wikipedia.org', referrer: 'http://opensource.org', created_at: Time.now-2.day}) }
  }
  after { Timecop.return }

  let(:urls_response) {
    {
        '2013-12-01' => [ { url: 'http://en.wikipedia.org', visits: 3 } ],
        '2013-12-02' => [ { url: 'http://developer.apple.com', visits: 30 } ],
        '2013-12-03' => [ { url: 'http://opensource.org', visits: 12 },
                          { url: 'http://apple.com', visits: 10 },
                          { url: 'https://apple.com', visits: 4 } ]
    }
  }

  let(:referrers_response) {
    {
        '2013-12-01' => [ { url: 'http://en.wikipedia.org', visits: 3, referrers: [{referrer: "http://opensource.org", visits: 3}] } ],
        '2013-12-02' => [ { url: 'http://developer.apple.com', visits: 30, referrers: [{referrer: nil, visits: 30}] } ],
        '2013-12-03' => [ { url: 'http://opensource.org', visits: 12, referrers: [{referrer: "http://en.wikipedia.org", visits: 12}] },
                          { url: 'http://apple.com', visits: 10, referrers: [{referrer: nil, visits: 10}] } ]
    }
  }

  describe '::pageviews_for_past_days' do
    it 'returns empty result when zero days passed' do
      expect(Visit.pageviews_for_past_days(0)).to eq({})
    end

    it 'pulls daily data' do
      expect(Visit.db).to receive(:fetch).exactly(5).times
      Visit.pageviews_for_past_days(5)
    end

    it 'calculates pageviews report for given days' do
      expect(Visit.pageviews_for_past_days(3)).to eq(urls_response)
    end
  end

  describe '::top_referrers_for_top_urls_for_days' do
    it 'returns empty result when zero days passed' do
      expect(Visit.top_referrers_for_top_urls_for_days(1, 2, 0)).to eq({})
    end

    it 'calculates pageviews and referrers for given params' do
      expect(Visit.top_referrers_for_top_urls_for_days(1, 2, 3)).to eq(referrers_response)
    end
  end
end