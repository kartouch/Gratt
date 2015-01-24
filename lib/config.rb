require 'fileutils'
=begin
Authentication module:
Read the information from ~/.gratt/gratt.conf
=end

module Gratt2config
  extend self
  def config_exists?
     File.exist?(ENV['HOME']+'/.gratt/gratt.conf')
  end

  def generate_config
    begin
      FileUtils.mkdir_p(ENV['HOME']+'/.gratt') unless File.directory?(ENV['HOME']+'/.gratt')
      file = File.new(ENV['HOME']+'/.gratt/gratt.conf', 'w')
      file.write("
##Gratt2 config file
#T411 Settings
username=username
password=password

#Limit amount of rows for search
search_limit=100

#Path for .torrent file download
local_path='/tmp'

#remote server
#remote_server=")
      Formatador.display_line("[green]Config file created in #{ENV['HOME']+'/.gratt/gratt.conf'}[/]")
    rescue IOError => e
      puts 'Something happened... Writable?'
    ensure
      file.close unless file == nil
    end
  end

  def from_file
    begin
    config = ParseConfig.new(ENV['HOME']+'/.gratt/gratt.conf')
    return config
    rescue
      puts 'Permission denied - file exists?'
    end

   end
end