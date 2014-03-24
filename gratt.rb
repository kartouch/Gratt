#!/usr/bin/ruby
require 'json'
require 'thor'
require 'sanitize'
require 'colored'
require 't411'

class Gratt < Thor
$server = 'Server IP'
T411.authenticate('username','password')

desc 'top category', 'Periods today,month,top100'
def top(period,cid = nil)
    JSON.parse(T411::Torrents.send(period.to_sym)).each do |item|
      case cid
        when 'documentaire' then puts "#{item['id']} #{item['name']}  #{item['size'].to_i/1000000} Mb" if item['category'].to_i == 634
        when 'film' then puts "#{item['id']} #{item['name']} #{item['size'].to_i/1000000} Mb" if item['category'].to_i == 631
        when 'serie' then puts "#{item['id']} #{item['name']} #{item['size'].to_i/1000000} Mb" if item['category'].to_i == 433
        when 'audiobook' then puts "#{item['id']} #{item['name']} #{item['size'].to_i/1000000} Mb" if item['category'].to_i == 405
        when 'animimation' then puts "#{item['id']} #{item['name']} #{item['size'].to_i/1000000} Mb" if item['category'].to_i == 433
       when nil then puts "#{item['id']} #{item['name']} #{item['size'].to_i/1000000} Mb"
      end
    end
end

desc 'search TITLE LIMIT CID','search on title and limit the amount of result'
def search(title,limit = 100, cid=nil)
  begin
    JSON.parse(T411::Torrents.search(title,limit: limit, cid: cid))['torrents'].each { |x|puts " #{x['id']}  #{x['name']} #{(x['size'].to_i/1000000)} Mb"}
  rescue
    puts 'No results found !!'
  end
end

desc 'download ID', 'download a specific ID'
def download(id)
  begin
  T411::Torrents.download(id)
  system("transmission-remote #{$server} -a #{id}.torrent && rm #{id}.torrent")
  rescue
   puts 'ID not found !!'
  end
end

desc 'details ID', 'details of an ID'
def details(id)
  begin
    puts Sanitize.clean(JSON.parse(T411::Torrents.details(id))['description']).yellow_on_black
  rescue
    puts 'ID Not found'
  end

end

end

Gratt.start(ARGV)