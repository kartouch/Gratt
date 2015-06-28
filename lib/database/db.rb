require 'parseconfig'
require 'active_record'

module  Gratt2db
 extend self
   def connect
    ActiveRecord::Base.establish_connection(
      adapter:  'postgresql',
      encoding: 'utf-8',
      host:     'localhost',
      database: 'gratt',
      username: 'kartouch')
   end
end

