require 'thor'
require 't411'
require 'parseconfig'
require './lib/auth'
require './lib/request'
require './lib/config'
require 'formatador'
require 'sanitize'
require './lib/database/db'
require './lib/database/wishlist'
require './lib/wishes'


class Gt411 < Thor
  namespace :t411
  include Gratt2auth
  include Gratt2config
  include Gratt2request
  include Gratt2wishes

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
      Gt411::Torrents.download(id,path)
    rescue
      puts 'ID not found !!'
    end
   add_to_remote_server(id)
  end

  desc 'details ID', 'details of an ID'
  def details(id)
    begin
      puts  Sanitize.clean(JSON.parse(Gt411::Torrents.details(id))['description']).gsub('  ',"\n")
    rescue
      puts 'ID Not found'
    end
  end

  desc 'generate', 'Generate the config file (REQUIRED)'
  def generate
    Gratt2config::generate_config
  end

  desc 'wishlist', 'Manage the wishlist'
  option :list, aliases: '-L', banner: 'List'
  option :delete, aliases: '-D', banner: 'Delete (requires: -id)'
  option :add, aliases: '-A'
  option :id, aliases: '-id'
  option :title, aliases: '-t'
  option :season, aliases: '-s'
  option :episode, aliases: '-e'
  option :lang, aliases: '-l'
  option :multiple, aliases: '-M'
  option :multiple_add, aliases: '-a'
  option :multiple_delete, aliases: '-d'
  option :start
  option :end
  def wishlist(*p)
    title = options[:title] if options[:title]
    season = options[:season] if options[:season]
    episode = options[:episode] if options[:episode]
    lang = options[:lang] if options[:lang]
    Gratt2wishes.list if options[:list]
    if options[:multiple]
      start = options[:start].to_i
      finish = options[:end].to_i
      while start <= finish do
        if options[:multiple_add]
          episode = start.to_s.gsub(start.to_s,"0#{start.to_s}")
          episode = episode[1..-1] if episode.size > 2
          Gratt2wishes.create(title,season,episode,lang)
        elsif options[:multiple_delete]
          Gratt2wishes.remove(start)
        end
        start +=1
      end
    end
   Gratt2wishes.remove(options[:id]) if options[:delete]
   Gratt2wishes.create(title,season,episode,lang) if options[:add]  
  end
  
  private 
  def add_to_remote_server(id)
    if File.exists?("/tmp/#{id}.torrent")
      `transmission-remote #{Gratt2config::from_file['transmission_server']} \
       --auth #{Gratt2config::from_file['transmission_user']}:#{Gratt2config::from_file['transmission_pwd']}\
       -a /tmp/#{id}.torrent`
    else
      puts 'File not found'
    end
  end


end
