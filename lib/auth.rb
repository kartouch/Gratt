require 't411'
require 'parseconfig'
require 'formatador'
module Gratt2auth
  extend self
  def auth
    if File.exist?(ENV['HOME']+'/.gratt/gratt.conf')
      T411::authenticate(ParseConfig.new(ENV['HOME']+'/.gratt/gratt.conf')['username'], ParseConfig.new(ENV['HOME']+'/.gratt/gratt.conf')['password'])
    else
      Formatador.display_line('[red]Config file exists? Please check ~/.gratt/gratt.conf[/]')
    end
  end
end