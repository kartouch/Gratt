require 'active_record'

class Wishlist < ActiveRecord::Base
  has_many :torrents
end

