#!/usr/bin/env ruby
require 'thor'
require 't411'
require 'parseconfig'
require '/usr/share/gratt/auth'
require '/usr/share/gratt/request'
require '/usr/share/gratt/config'
require 'formatador'
require 'sanitize'

class Gratt < Thor
  include Gratt2auth
  include Gratt2config
  include Gratt2request

  Gratt2auth::auth
  $categories = {documentary:634,
                 movie:631,
                 serie:433}

  desc 'top LIST','Predefined lists based on popularity and period'
  long_desc <<-LONGDESC
    The available list are : top100, today, week, month \n
    Additional parameter can be the category. \n
    Available categories : movie, serie, documentary
  LONGDESC
  option :category, aliases: '-c', type: :string
  def top(list)
    cat = $categories[options[:category].to_sym] if options[:category]
    Formatador.display_table(Gratt2request::t411_top(list,cat),[:id,:name,:size,:added])
  end

  desc 'search TITLE','search on title and limit the amount of result'
  option :category, aliases: '-c', type: :string
  option :limit, aliases: '-l', type: :numeric
  option :date, aliases: '-d', type: :string
  option :from, aliases: '-f', type: :string
  option :till, aliases: '-t', type: :string

  def search(title,limit=Gratt2config::from_file['search_limit'],cid=nil)
    cid = $categories[options[:category].to_sym] if options[:category]
    limit = options[:limit] if options[:limit]
    date = options[:date] if options[:date]
    from = options[:from] if options[:from]
    till = options[:till] if options[:till]
    Formatador.display_table( Gratt2request::t411_search(title,limit,cid,date,from,till),[:id,:name,:size,:added])
  end

  desc 'download ID', 'download a specific ID'
  long_desc <<-LONGDESC
    The default location is set in the config file.
    When not set, it will download in the folder of the application \n
    The value to set is in config file is : local_path='/your/path' \n
    This value can be overridden with -p parameter.
  LONGDESC
  option :path, aliases: '-p'
  def download(id)
   if options[:path].nil?
     path = Gratt2config::from_file['local_path']
   else
     path = options[:path]
   end
    begin
      T411::Torrents.download(id,path)
    rescue
      puts 'ID not found !!'
    end
  end

  desc 'details ID', 'details of an ID'
  def details(id)
    begin
     puts  Sanitize.clean(JSON.parse(T411::Torrents.details(id))['description']).gsub('  ',"\n")
    rescue
      puts 'ID Not found'
   end
  end

  desc 'generate', 'Generate the config file (REQUIRED)'
  def generate
    Gratt2config::generate_config
  end
end

Gratt.start(ARGV)

