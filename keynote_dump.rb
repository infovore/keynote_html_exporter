#!/usr/bin/env ruby 

STDOUT.sync = true
require 'rubygems'
require 'erb'
require 'appscript'
include Appscript

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

def tidy(text)
  text.gsub("<p></p>", "").gsub("\n\n\n", "\n")
end


shortname = ARGV[0]
template = ARGV[1]
aspect_ratio = ARGV[2]

unless shortname && template
  puts "Usage: keynote_dump.rb shortname_for_slides template_file [imagemagick_resize_ratio]"
  puts "Optional resize ratio should be of the format (eg) 300x225"
else
  if aspect_ratio
    require 'rmagick'
    include Magick
    width = aspect_ratio.split("x").first.to_i
    height = aspect_ratio.split("x").last.to_i
    if width && height
      puts "Resizing all slides in #{shortname}/"
      Dir.glob("#{shortname}/*.png") do |file|
        ImageList.new(file).resize(width,height).write(file)
        print "."
      end
      puts 
    else
      puts "Invalid resizing format. Slides will not be resized"
    end
  end

  puts "Exporting notes from Keynote"
  keynote = app("Keynote")
  @notes = []

  keynote.slideshows.get.first.slides.get.each do |slide|
    output = make_ascii(slide.notes.get)
    output = create_breaks_around(output)
    output = tidy(output)
    @notes << output
    print "."
  end
  puts
  template = File.open(template) {|f| f.read }
  
  output = ERB.new(template)
  
  File.open("#{shortname}/#{shortname}.html", "w") do |f|
    f << output.result
  end
  
end