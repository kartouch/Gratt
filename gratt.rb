#!/usr/bin/env ruby
require 'thor'
require 't411'
require 'parseconfig'
require './lib/auth'
require './lib/request'
require './lib/config'
require './lib/gt411'
require './lib/yify'
require 'formatador'
require 'sanitize'



class Gratt < Thor
  include Yts
  register(Gt411, 't411', 't411 <command>', 'Access T411')
  register(Gyify, 'yify', 'yify <command>', 'Access YTS')
end

Gratt.start(ARGV)

