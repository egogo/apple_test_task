AppleTestTask::Application.routes.draw do
  get '/top_referrers' => 'stats#top_referrers'
  get '/top_urls' => 'stats#top_urls'
end
