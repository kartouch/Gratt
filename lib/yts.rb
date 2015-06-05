require 'httparty'
require 'ostruct'
require 'nokogiri'
require 'open-uri'

module Yts
  extend self
  def movie_list(*p)
    str = []
    p.each{|x| str << x}
    resp = HTTParty.get "https://yts.to/api/v2/list_movies.json?#{str.*','.gsub(',','&')}"
    resp['data']['movies']
  end

  def movie_endpoints
    %w'movie_details movie_suggestions movie_reviews movie_parental_guides movie_comments'
  end

  movie_endpoints.each do |i|
    define_method(i.to_sym) do |movie_id,*p|
      str = []
      p.each{|x| str << x}
      if str.empty?
        resp = HTTParty.get "https://yts.to/api/v2/#{i}.json?movie_id=#{movie_id}"
      else
        resp = HTTParty.get "https://yts.to/api/v2/#{i}.json?movie_id=#{movie_id}&#{str.*','.gsub(',','&')}"
      end
      OpenStruct.new(resp['data'])
    end
  end

  def find_subtitles(imdb,lang)
    resp = Nokogiri::HTML(open("http://www.yifysubtitles.com/movie-imdb/#{imdb}"))
    arr = resp.search('#movie-info > div.movie-info-right > ul.other-subs').map{|li| li.search('a').map {|a| a['href'].chomp} }
    new = []
    subs = []
    for i in 0.. arr[0].size
      new <<  arr[0][i] if  arr[0][i].to_s.include?(lang)
    end
    new = new.uniq
    new.each {|x| subs << 'http://www.yifysubtitles.com/'+x.to_s.gsub('subtitles','subtitle')+'.zip'}
    subs
  end
end