require 'active_record'

class Torrents < ActiveRecord::Base
  validates :wishlist_id, uniqueness: true
end

