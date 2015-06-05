require 'thor'
require './lib/yts'
require './lib/config'


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
    Yts.find_subtitles(Yts.movie_details(id).imdb_code,Gratt2config::from_file['subs_lang']).each do |x|
       `cd #{Gratt2config::from_file['subs_path']}; curl -O #{x}; unzip #{x.gsub('http://www.yifysubtitles.com//subtitle/','')}; rm -f *.zip`
    end
  end
end
