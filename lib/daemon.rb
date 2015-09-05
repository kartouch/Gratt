require 'active_record'
require 'table_print'
require 't411'

module Gratt2daemon
  extend self
  begin
  Gratt2auth.auth
  rescue
#    raise 'T411 is not availabe'
  end
  Gratt2db.connect
  
  def check
    Wishlist.all.each do |i|
      if i.season.nil?
        push_to_list(i.id)  if JSON.parse(T411::Torrents.search(i.title, cid: 631))['total'].to_i > 0
      else
        push_to_list(i.id) if JSON.parse(T411::Torrents.search("#{i.title}.S#{i.season}E#{i.episode}.#{i.lang}"))['total'].to_i > 0
      end
    end
  end

  def list_available
    tp ActiveRecord::Base.connection.execute("select w.id,w.title,w.season, w.episode, w.lang, t.available, t.downloaded from wishlists as w inner join torrents as t on w.id = t.wishlist_id where t.available = 't' and t.downloaded = 'f';")
  end
  
  def push_to_list(wishlist_id)
    Torrent.create(wishlist_id: wishlist_id, available: true, downloaded: false)
  end

  def remove_from_list(wishlist_id)
    begin
    Torrent.where(wishlist_id: wishlist_id).first.destroy
    rescue
    end
  end

  def mark_as_downloaded(wishlist_id)
    torrent = Torrent.where(wishlist_id: wishlist_id).first
    torrent.downloaded = true
    torrent.save
  end

end

