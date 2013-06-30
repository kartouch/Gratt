#!/usr/bin/ruby
require 'rest_client'
require 'json'
require 'thor'
require 'sanitize'
require 'colored'

class Gratt < Thor
$server = 'Server IP'
username = 'Your login'
password = 'Your Pwd'
$t411_api = 'https://api.t411.me'
login = RestClient.post "#{$t411_api}/auth", { 'username' => "#{username}", 'password' => "#{password}" }, :content_type => :json, :accept => :json
$auth = JSON.parse(login)

desc 'top', 'Periods today,week,month,top100  && cat: film, documentaire, serie, audiobook, animation'
def top(period,cat)
  begin
  periods = {today: 'today', week: 'week', month: 'month', top100: 'top100' }
  category = {film: 631, documentaire: 634, serie: 433, audiobook: 405, animation: 455}
  request = RestClient.get "#{$t411_api}/torrents/top/#{periods[:"#{period}"]}", headers = {Authorization: "#{$auth['token']}" }
  today = JSON.parse(request)
  today.each do |item|
    if item['category'].to_i == category[:"#{cat}"]
    puts item['id'] + ' ' + item['name'] + ' ' + item['category']
    end
  end
  rescue
   puts 'Error !!'
  end
end

desc 'search TITLE LIMIT','search on title and limit the amount of result'
def search(title,limit = 50)
  title = title.dup
  while title.include?(' ') do
  title.sub!(/ /, '+')
  end
  begin
  request = RestClient.get "#{$t411_api}/torrents/search/#{title}&offset=10&limit=#{limit}", headers = {Authorization: "#{$auth['token']}" }
  search = JSON.parse(request)
  search['torrents'].each do |x|
  puts " #{x['id']}  #{x['name']} #{(x['size'].to_i/1000000)} Mb"
  end
  rescue
    puts 'No results found !!'
  end
end

desc 'download ID', 'download a specific ID'
def download(id)
  begin
  request = RestClient.get "#{$t411_api}/torrents/download/#{id}", headers = {Authorization: "#{$auth['token']}" }
  File.open("#{id}.torrent", "a+") do |line|
    line.puts request
  end
  system("transmission-remote #{$server} -a #{id}.torrent")
  system("rm #{id}.torrent ")
  rescue
   puts 'ID not found !!'
  end
end

desc 'details ID', 'details of an ID'
def details(id)
  begin
  request = RestClient.get "#{$t411_api}/torrents/details/#{id}", headers = {Authorization: "#{$auth['token']}" }
  details = JSON.parse(request)
  puts Sanitize.clean(details['description']).yellow_on_black
  rescue
  puts 'ID not found !!'
  end
end

end

Gratt.start(ARGV)