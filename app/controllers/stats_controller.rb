class StatsController < ApplicationController
  respond_to :json

  def top_urls
    respond_with Visit.pageviews_for_past_days(5)
  end

  def top_referrers
    respond_with Visit.top_referrers_for_top_urls_for_days(5, 10, 5)
  end
end
