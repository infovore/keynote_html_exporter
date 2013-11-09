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