require 'active_record'

class Torrent < ActiveRecord::Base
  validates :wishlist_id, uniqueness: true
end

