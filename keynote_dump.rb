#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'rbosa'
require 'erb'

OSA.utf8_strings = true

shortname = ""

def make_ascii(string)
  string = string.gsub("\r", "\n")
  
  string = string.gsub("\xe2\x80\x94", "--") # m dash
  string = string.gsub("\xe2\x80\x98", "'")  # open single quote
  string = string.gsub("\xe2\x80\x99", "'")  # close single quote
  string = string.gsub("\xe2\x80\x9c", '"')  # open double quote
  string = string.gsub("\xe2\x80\x9d", '"')  # close double quote

  string = string.gsub("\xc3\xa1", "&#225;") # aacute
  string = string.gsub("\xc3\x87", "&#199;") # Ccedil
  string = string.gsub("\xc3\xb6", "&#246;") # ouml
  string = string.gsub("\xc3\xbc", "&#252;") # uuml
  string = string.gsub("\xc3\xa8", "&#232;") # egrave
  
  string.strip
end

def create_breaks_around(text)
  "<p>#{text.gsub(/\n/, "</p>\n\n<p>")}</p>"
end

app = OSA.app("Keynote")
@notes = []

app.slideshows.first.slides.each do |slide|
  @notes << create_breaks_around(make_ascii(slide.notes))
end

template = File.open("template.html.erb") {|f| f.read }

output = ERB.new(template)

puts output.result
puts
puts "Now export all slides as images from Keynote to ./slides"