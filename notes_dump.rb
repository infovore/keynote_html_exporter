#!/usr/bin/env ruby 

STDOUT.sync = true
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }


keynote = Appscript::app("Keynote")
@notes = []

keynote.slideshows.get.first.slides.get.each do |slide|
  output = slide.notes.get
  puts output
  puts
  puts "-------"
  puts
end
