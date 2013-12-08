class Visit < Sequel::Model

  class << self
    # TODO: add cache for non-today queries

    #  1. number of page views per URL, grouped by day, for the past 5 days;
    def pageviews_for_past_days(days)
      return {} if days < 1
      1.upto(days).inject(Hash.new) do |result, day|
        from, to = (Date.today-(day-1).days).to_s(:db), (Date.today-day.days).to_s(:db)
        result[from] = self.db.fetch("select url, count(*) as visits \
                                      from ? \
                                      where created_at <= ? and created_at > ? \
                                      group by url \
                                      order by visits desc", self.table_name, from, to).to_a
        result
      end
    end

    #  2. top 5 referrers for the top 10 URLs grouped by day, for the past 5 days.
    def top_referrers_for_top_urls_for_days(ref_n, url_n, days)
      pageviews_for_past_days(days).inject({}) do |memo,(k,r)|
        memo[k] = r[0...url_n]
        date = Date.parse(k)
        urls = memo[k].collect {|j| j[:url] }

        refs = self.db.fetch("select url, referrer, count(*) as visits \
                              from ? \
                              where created_at >= ? and created_at < ? \
                              and url in ? \
                              group by url, referrer \
                              order by visits desc", self.table_name, date, date+1.day, urls).to_a

        memo[k].each_index do |i|
          memo[k][i][:referrers] = refs.map do |r|
            if r[:url] == memo[k][i][:url]
              {referrer: r[:referrer], visits: r[:visits]}
            end
          end.compact.take(ref_n)
        end

        memo
      end
    end


    # Adding non datetime field to records will speed things up alot
    #def faster_pageviews_for_past_days(days)
    #  fetch("select url, count(*) as visits, date_created \
    #         from visits \
    #         where date_created >= (CURDATE() - INTERVAL #{days} DAY) \
    #         group by url, date_created \
    #         order by date_created asc, visits asc").to_a
    #end

  end

end
