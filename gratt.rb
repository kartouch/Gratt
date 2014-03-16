#!/usr/bin/ruby
require 'json'
require 'thor'
require 'sanitize'
require 'colored'
require 't411'

class Gratt < Thor
$server = 'Server IP'
T411.authenticate('username','password')

desc 'top', 'Periods today,month,top100'
def top(period)
  result = JSON.parse(T411::Torrents.send(period.to_sym))
  result.each do |item|
    puts item['id'] + ' ' + item['name'] + ' ' + item['category']
  end
end

desc 'search TITLE LIMIT','search on title and limit the amount of result'
def search(title,limit = 100)
  begin
    JSON.parse(T411::Torrents.search(title,limit))['torrents'].each do |x|
    puts " #{x['id']}  #{x['name']} #{(x['size'].to_i/1000000)} Mb"
  end
  rescue
    puts 'No results found !!'
  end
end

desc 'download ID', 'download a specific ID'
def download(id)
  begin
  T411::Torrents.download(id)
  system("transmission-remote #{$server} -a #{id}.torrent")
  system("rm #{id}.torrent ")
  rescue
   puts 'ID not found !!'
  end
end

desc 'details ID', 'details of an ID'
def details(id)
  begin
    details = JSON.parse(T411::Torrents.details(id))
    puts Sanitize.clean(details['description']).yellow_on_black
  rescue
    puts 'ID Not found'
  end

end

end

Gratt.start(ARGV)