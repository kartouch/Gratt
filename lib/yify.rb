require 'thor'
require './lib/yts'
require './lib/config'
require 'find'

class Gyify < Thor

  desc 'search TITLE','search on title and limit the amount of result'
  def search(title)
    data = []
    Yts.movie_list("query_term=#{title}").each do |x|
      subs = 'Y' if Yts.find_subtitles(x['imdb_code'],'french').size != 0 rescue []
      data << { id: x['id'], name: x['title_long'], added: x['date_uploaded'], subs: subs }
    end
    Formatador.display_table( data,[:id,:name,:added, :subs])
  end

  desc 'download ID','Download the movie and subtitles '
  def download(id)
    File.write("/tmp/#{Yts.movie_details(id).id}"+'.torrent', "#{HTTParty.get Yts.movie_details(id).torrents[0]['url']}")
    subs_list(id).each do |x|
       `cd #{Gratt2config::from_file['subs_path']};\
        curl -O #{x};\
        unzip #{x.gsub('http://www.yifysubtitles.com//subtitle/','')};\
        rm -f *.zip`
    add_to_remote_server(id)
    send_subs
    end
  end
 
  private

  def subs_list(id)
    Yts.find_subtitles(Yts.movie_details(id).imdb_code,Gratt2config::from_file['subs_lang'])
  end

  def add_to_remote_server(id)
    if File.exists?("/tmp/#{id}.torrent")
      `transmission-remote #{Gratt2config::from_file['transmission_server']} \
       --auth #{Gratt2config::from_file['transmission_user']}:#{Gratt2config::from_file['transmission_pwd']}\
       -a /tmp/#{id}.torrent`
    else
      puts 'File not found'
    end
  end

  def send_subs
    srt_files = []
    Find.find(Gratt2config::from_file['subs_path']) do |path|
        srt_files << path if path =~ /.*\.srt$/
    end
    srt_files.each do |file|
    `scp #{file} #{Gratt2config::from_file['subs_remote_server']}:#{Gratt2config::from_file['subs_remote_path']}`
      `rm -f #{file}`
    end
  end
end
