Visit.dataset.delete

RANDOM_URLS = %w(http://dev.stephendiehl.com/hask/ http://booktwo.org/notebook/anatomy-failed-rendition-ifa-muaza/
              http://www.cnbc.com/id/101253202 http://stackoverflow.com/a/80113 http://www.dragonflybsd.org/
              http://www.vineclient.com/ http://probcomp.csail.mit.edu/bayesdb/ http://mywiki.wooledge.org/Bashism
              http://blog.pluralsight.com/elixir-is-for-programmers http://techcrunch.com/2013/12/07/a-modest-proposal/)

URLS = %w(http://apple.com https://apple.com https://www.apple.com http://developer.apple.com http://en.wikipedia.org
          http://opensource.org)+RANDOM_URLS

REFERRERS = %w(http://apple.com https://apple.com https://www.apple.com http://developer.apple.com )+[nil]+RANDOM_URLS

count = 0
batch_size = 10000
total = 1_000_000

(1..total/batch_size).to_a.each do |batch|
  (1..batch_size).each do |i|
    visit_datetime = Time.now-rand(count/total*15.days.to_i)
    visit = {
               id: count+i, url: URLS[rand(URLS.count)],
               referrer: REFERRERS[rand(REFERRERS.count)],
               created_at: visit_datetime,
               # date_created: visit_datetime.to_date
            }
    Visit.insert(visit.merge({hash: Digest::MD5.hexdigest(visit.delete_if {|k,v| v.nil?}.to_s)}))
  end
  count += batch_size
  puts "#{count} records of #{total} inserted"
end