#!/usr/bin/env ruby 

STDOUT.sync = true
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

#shortname = ARGV[0]
#slide_template = ARGV[1]
#page_template = ARGV[2]
#aspect_ratio = ARGV[3]

shortname, slide_template, page_template, aspect_ratio = ARGV

unless shortname && slide_template && page_template
  puts "Usage: keynote_dump.rb shortname_for_slides slide_template_file page_template_file [imagemagick_resize_ratio]"
  puts "Optional resize ratio should be of the format (eg) 300x225"
  exit
end

if aspect_ratio
  begin
    puts "Resizing all slides in #{shortname}/img"
    Dir.glob("#{shortname}/img/*.png") do |file|
      image = MiniMagick::Image.open(file)
      image.resize aspect_ratio
      image.write(file)
      print "."
    end
    puts 
  rescue
    puts "Invalid resizing format. Slides will not be resized"
  end
end

puts "Exporting notes from Keynote"

keynote = KeynoteProcessor.new('Keynote')
keynote.ingest!

kt = SlideTemplater.new(File.read(slide_template), File.read(page_template), shortname)

File.open("#{shortname}/#{shortname}.html", "w") do |f|
  f << kt.process_keynote(keynote)
end

