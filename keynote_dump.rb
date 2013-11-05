#!/usr/bin/env ruby 

STDOUT.sync = true
require 'rubygems'
require 'erubis'
require 'appscript'
require 'iconv'

class KeynoteProcessor
  include Appscript
  attr_reader :slides, :app

  def initialize(app_name)
    @app = Appscript.app(app_name)
    @slides = []
  end

  def ingest!
    app.slideshows.get.first.slides.get.each do |s|
      slide = Slide.new(s.notes.get)
      @slides << slide
    end
  end
end

class Slide
  attr_reader :raw_text, :formatted_notes
  def initialize(raw)
    @raw_text = raw
    @formatted_notes = process_raw
  end

  def process_raw
    o = Slide.create_breaks_around(Slide.make_ascii(@raw_text))
    o = Slide.tidy(o)
  end

  def self.create_breaks_around(text)
    "<p>#{text.gsub(/\n/, "</p>\n\n<p>")}</p>"
  end

  def self.tidy(text)
    text.gsub("<p></p>", "").gsub("\n\n\n", "\n")
  end

  def self.make_ascii(string)
    string = string.force_encoding('ASCII-8BIT')
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
end

class SlideTemplater
  attr_reader :slide_template, :page_template_string, :shortname

  def initialize(slide_template_string, page_template_string, shortname)
    @slide_template = slide_template_string
    @page_template = page_template_string
    @shortname = shortname
  end

  def process_keynote(keynote_obj)
    process_page(keynote_obj)
  end

  def process_slides(keynote_obj)
    # take the keynote obj, template up each slide, stick them in an array.
    output = []
    keynote_obj.slides.each_with_index do |s, i|
      eruby = Erubis::Eruby.new(@slide_template)
      notes = s.formatted_notes
      index = i
      shortname = @shortname
      templated = eruby.evaluate(:notes => s.formatted_notes,
                                 :index => i,
                                 :shortname => @shortname)
      output << templated 
    end
    # return the entire html
    output
  end

  def process_page(keynote_obj)
    all_slides = process_slides(keynote_obj).join("\n")
    eruby = Erubis::Eruby.new(@page_template)
    eruby.evaluate(:all_slides => all_slides)
  end
end

shortname = ARGV[0]
slide_template = ARGV[1]
page_template = ARGV[2]
aspect_ratio = ARGV[3]

unless shortname && slide_template && page_template
  puts "Usage: keynote_dump.rb shortname_for_slides slide_template_file page_template_file [imagemagick_resize_ratio]"
  puts "Optional resize ratio should be of the format (eg) 300x225"
  exit
end

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

keynote = KeynoteProcessor.new('Keynote')
keynote.ingest!

kt = SlideTemplater.new(File.read(slide_template), File.read(page_template), shortname)

File.open("#{shortname}/#{shortname}.html", "w") do |f|
  f << kt.process_keynote(keynote)
end

