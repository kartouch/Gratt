require 'formatador'
module Gratt2request
  extend self
  def t411_top(list,cat)
    data = []
    JSON.parse(T411::Torrents.send(list.to_sym)).each do |t|
      if cat.nil?
        push_to_data(data,t)
      elsif t['category'].to_i == cat
        push_to_data(data,t)
      end
    end
   data
  end

  def t411_search(title,limit,cid,date,from,till)
    data = []
     begin
      JSON.parse(T411::Torrents.search(title,limit: limit, cid: cid))['torrents'].each do |t|
        if !date.nil? && (!from.nil? || !till.nil?)
          Formatador.display_line('[red]Invalid request! -d or --date must be used alone[/]'); break
        elsif !date.nil?
          push_to_data(data,t) if t['added'].to_s.split(' ')[0] == date
        elsif !from.nil? && !till.nil?
          push_to_data(data,t) if Date.parse(t['added'].to_s.split(' ')[0]).between?(Date.parse(from),Date.parse(till))
        elsif !from.nil?
          push_to_data(data,t) if Date.parse(t['added'].to_s.split(' ')[0]) > Date.parse(from)
        elsif !till.nil?
          push_to_data(data,t) if Date.parse(t['added'].to_s.split(' ')[0]) < Date.parse(till)
        else
          push_to_data(data,t)
        end
      end
      rescue
      puts 'No results found !! Mistakes in command? Date?'
    end
    data
  end

  def push_to_data(data,t)
    data << {id: t['id'], name: t['name'].to_s[0..100], size: "#{t['size'].to_i / 1000000} MB", cat: t['category'], added: t['added'].to_s.split(' ')[0], seeders: t['seeders'] }
  end
end