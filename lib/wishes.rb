require 'active_record'
require './lib/database/db'
require './lib/database/wishlist'
require 'table_print'

module Gratt2wishes
  extend self
  Gratt2db.connect
  
  def list
   tp Wishlist.all
  end

  def create(title,season=nil,episode=nil,lang=nil)
    Wishlist.create(title: title, season: season, episode: episode, lang: lang, downloaded: false)
  end

  def remove(id)
    Wishlist.find(id).destroy
  end
end
